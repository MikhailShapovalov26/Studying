# Postgres
## 1.
Docker-compose в директории. 
- Вывода списка БД

        l
                                    List of databases
        Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
        -----------+-------+----------+------------+------------+-------------------
        postgres  | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
        template0 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
                |       |          |            |            | test=CTc/test
        template1 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
                |       |          |            |            | test=CTc/test
        test      | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
        (4 rows)
- подключения к БД

        SELECT * from pg_stat_activity;
- вывода списка таблиц

        \dt *.*
                            List of relations
            Schema       |          Name           | Type  | Owner 
        --------------------+-------------------------+-------+-------
        information_schema | sql_features            | table | test
        information_schema | sql_implementation_info | table | test
        information_schema | sql_parts               | table | test
        information_schema | sql_sizing              | table | test
        pg_catalog         | pg_aggregate            | table | test
        pg_catalog         | pg_am                   | table | test
        pg_catalog         | pg_amop                 | table | test
        pg_catalog         | pg_amproc               | table | test
- вывода описания содержимого таблиц

        \dT *.*
                                                                List of data types
            Schema       |                Name                |                               Description                               
        --------------------+------------------------------------+-------------------------------------------------------------------------
        information_schema | information_schema.cardinal_number | 
        information_schema | information_schema.character_data  | 
        information_schema | information_schema.sql_identifier  | 
        information_schema | information_schema.time_stamp      | 
        information_schema | information_schema.yes_or_no       | 
        pg_catalog         | aclitem                            | access control list
        pg_catalog         | "any"                              | pseudo-type representing any type
        pg_catalog         | anyarray                           | pseudo-type representing a polymorphic array type
        pg_catalog         | anycompatible                      | pseudo-type representing a polymorphic common type
        pg_catalog         | anycompatiblearray                 | pseudo-type representing an array of polymorphic common type elements
        pg_catalog         | anycompatiblenonarray              | pseudo-type representing a polymorphic common type that is not an array
        pg_catalog         | anycompatiblerange                 | pseudo-type representing a range over a polymorphic common type
        pg_catalog         | anyelement                         | pseudo-type representing a polymorphic base type
        pg_catalog         | anyenum                            | pseudo-type representing a polymorphic base type that is an enum
        pg_catalog         | anynonarray                        | pseudo-type representing a polymorphic base type that is not an array
- Выхода из psql

        \q                     quit psql

## 2.
        createdb -p 5432 -U test test_database
        test=# \l
                                    List of databases
            Name      | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
        ---------------+-------+----------+------------+------------+-------------------
        postgres      | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
        template0     | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
                    |       |          |            |            | test=CTc/test
        template1     | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
                    |       |          |            |            | test=CTc/test
        test          | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
        test_database | test  | UTF8     | en_US.utf8 | en_US.utf8 | 

Загружаем дамп памяти

        psql -U test -d test_database < /var/lib/postgres/data/pgdata/test_dump.sql
        SET
        SET
        SET
        SET
        SET
        set_config 
        ------------
        
        (1 row)

        SET
        SET
        SET
        SET
        SET
        SET
        CREATE TABLE
        ERROR:  role "postgres" does not exist (какие-то ошибки)
        CREATE SEQUENCE
        ERROR:  role "postgres" does not exist
        ALTER SEQUENCE
        ALTER TABLE
        COPY 8
        setval 
        --------
            8
        (1 row)

        ALTER TABLE
Проверяем 

        \d+
                                        List of relations
        Schema |     Name      |   Type   | Owner | Persistence |    Size    | Description 
        --------+---------------+----------+-------+-------------+------------+-------------
        public | orders        | table    | test  | permanent   | 8192 bytes | 
        public | orders_id_seq | sequence | test  | permanent   | 8192 bytes | 
        (2 rows)
сбор статистики по таблице

        ANALYZE orders;
        ANALYZE
        test_database=# EXPLAIN SELECT * FROM orders;
                            QUERY PLAN                       
        -------------------------------------------------------
        Seq Scan on orders  (cost=0.00..1.08 rows=8 width=24)
        (1 row)

        SELECT attname,avg_width FROM pg_stats WHERE tablename = 'orders';
        attname | avg_width 
        ---------+-----------
        id      |         4
        title   |        16
        price   |         4
        (3 rows)

## 3.
получилось сделать только партицирование.
Для этого понадобиться смоздать 2 таблицы по аналогии с главной таблицей, но при условии, что в первой цена будет выше 499, а во второй все остальные. 

        CREATE TABLE orders_1( CHECK (price>499)) INHERITS (orders);
        CREATE TABLE
        test_database=# select * from orders_1;
        id | title | price 
        ----+-------+-------
        (0 rows)

        CREATE TABLE orders_2 ( CHECK (price<=499)) INHERITS (orders);
        CREATE TABLE
        test_database=# select * from orders_2;
        id | title | price 
        ----+-------+-------
        (0 rows)
* называть новые таблицы лучше orders_price_0_499 чтоб пользователи понимали ограничения наложенные на данную талицу.
Теперь мы должны наложить условия, что-бы при работе с нашей таблицей при вставки нового значения, оно попадало в основную таблицу и новую созданную.

        CREATE RULE orders_insert_1 AS ON INSERT TO orders WHERE (price>499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
        CREATE RULE
Это правило. (для второй табл аналогичная запись но с другим условием)
Далее проверяем
Вставляем запись

        INSERT INTO orders ( id, title, price) VALUES (9, 'TEST', 700);
        INSERT 0 0
        test_database=# select * from orders;
        id |        title         | price 
        ----+----------------------+-------
        1 | War and peace        |   100
        2 | My little database   |   500
        3 | Adventure psql time  |   300
        4 | Server gravity falls |   300
        5 | Log gossips          |   123
        6 | WAL never lies       |   900
        7 | Me and my bash-pet   |   499
        8 | Dbiezdmin            |   501
        9 | TEST                 |   700
        (9 rows)

        test_database=# select * from orders_1;
        id | title | price 
        ----+-------+-------
        9 | TEST  |   700
        (1 row)
И проверяем. Видим, что при вставке в основную таблицу, запись попала и в резервную_1.

Можно было изначально так сделать, создав такие условия изначально. К примеру если у нас будет продукция до 1000 рублей, можно было разбить по 500 в каждой. И далее при заполнении записи дублировались, но при работе и поиске данных это бы сэкономило время для поиска. Можно же использовать партицирование по нескольким условиям. 
## 4.

        pg_dump -U test test_database > /var/lib/postgres/data/pgdata/test_new.dump
просто добавить UNIQUE, либо  UNIQUE(имя столбца)

        title character varying(80) NOT NULL UNIQUE,