# 6.3. MySQL
## 1.
Пишем манифест с volumes

    version: '3.3'
    services:
       db:
          image: mysql:8.0
          cap_add:
             - SYS_NICE
          restart: always
          hostname: mysql
          container_name: mysql
          environment:
             MYSQL_DATABASE: 'net'
             MYSQL_USER: 'net'
             MYSQL_ROOT_PASSWORD: 'net'
             MYDATA: /var/lib/mysql/
          ports:
             - '3306:3306'
          volumes:
             - db:/var/lib/mysql
    volumes:
       db:
         driver: local
Далее переходим в контейнер

    docker exec -it mysql bash

Восстановление базы данных из dump

    mysql -u root -p net < /var/lib/mysql/test_dump.sql
    Enter password:
Далее смотрим список БД

     SHOW DATABASES;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | net                |
    | performance_schema |
    | sys                |
    +--------------------+
    5 rows in set (0.01 sec)
Cписок таблиц из этой БД
 
     SHOW TABLES;
    +---------------+
    | Tables_in_net |
    +---------------+
    | orders        |
    +---------------+
    1 row in set (0.00 sec)
 Проверяем таблицу 
 
     select * from orders;
    +----+-----------------------+-------+
    | id | title                 | price |
    +----+-----------------------+-------+
    |  1 | War and Peace         |   100 |
    |  2 | My little pony        |   500 |
    |  3 | Adventure mysql times |   300 |
    |  4 | Server gravity falls  |   300 |
    |  5 | Log gossips           |   123 |
    +----+-----------------------+-------+
    5 rows in set (0.00 sec)
статуса БД

     \s
    --------------
    mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)
    
    Connection id:          23
    Current database:       net
    Current user:           root@127.0.0.1
    SSL:                    Cipher in use is TLS_AES_256_GCM_SHA384
    Current pager:          stdout
    Using outfile:          ''
    Using delimiter:        ;
    Server version:         8.0.29 MySQL Community Server - GPL
    Protocol version:       10
    Connection:             127.0.0.1 via TCP/IP
    Server characterset:    utf8mb4
    Db     characterset:    utf8mb4
    Client characterset:    latin1
    Conn.  characterset:    latin1
    TCP port:               3306
    Binary data as:         Hexadecimal
    Uptime:                 1 day 16 hours 49 min 47 sec
    
    Threads: 2  Questions: 57  Slow queries: 0  Opens: 169  Flush tables: 3  Open tables: 87  Queries per second avg: 0.000
    
     select * from orders where price >300;
    +----+----------------+-------+
    | id | title          | price |
    +----+----------------+-------+
    |  2 | My little pony |   500 |
    +----+----------------+-------+
    1 row in set (0.00 sec)
    select count(*) from orders where price >300;
    +----------+
    | count(*) |
    +----------+
    |        1 |
    +----------+
    1 row in set (0.00 sec)
## 2.
Создадим пользователя test

    CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
    Query OK, 0 rows affected (0.04 sec)
    
     ALTER USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass';
    Query OK, 0 rows affected (0.02 sec)  
      
    ALTER USER 'test'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;
    Query OK, 0 rows affected (0.02 sec)

    ALTER USER  'test'@'localhost' WITH   MAX_USER_CONNECTIONS 3  MAX_QUERIES_PER_HOUR 100;
    Query OK, 0 rows affected (0.01 sec)

    GRANT SELECT on *.* TO 'test'@'localhost';
    Query OK, 0 rows affected, 1 warning (0.02 sec)

    
 ## 3.
     SET profiling = 1;
    Query OK, 0 rows affected, 1 warning (0.00 sec)
    
    SHOW PROFILES;
    +----------+------------+---------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                               |
    +----------+------------+---------------------------------------------------------------------+
    |        1 | 0.00047300 | SET profiling = 1                                                   |
    |        2 | 0.00029075 | Query OK, 0 rows affected, 1 warning (0.00 sec)
    
     SET profiling = 1 |
    +----------+------------+---------------------------------------------------------------------+
    2 rows in set, 1 warning (0.00 sec)
    SHOW TABLE STATUS FROM net  LIKE 'orders'\G;
    *************************** 1. row ***************************
               Name: orders
               
             Engine: InnoDB
             
            Version: 10
         Row_format: Dynamic
               Rows: 5
     Avg_row_length: 3276
        Data_length: 16384
    Max_data_length: 0
       Index_length: 0
          Data_free: 0
     Auto_increment: 6
        Create_time: 2022-05-31 15:58:26
        Update_time: 2022-05-31 15:58:27
         Check_time: NULL
          Collation: utf8mb4_0900_ai_ci
           Checksum: NULL
     Create_options:
            Comment:
    1 row in set (0.01 sec)
    
изменяем engine на MyISAM

    ALTER TABLE net.orders ENGINE=MyISAM;
    Query OK, 5 rows affected (0.10 sec)
    Records: 5  Duplicates: 0  Warnings: 0
проверяем время выполнения:

       10 | 0.10548525 | ALTER TABLE net.orders ENGINE=MyISAM 
    
Проверяем (весь листинг не прикладываю)

     SHOW TABLE STATUS FROM net  LIKE 'orders'\G;
    *************************** 1. row ***************************
               Name: orders
             Engine: MyISAM
            Version: 10
InnoDB возращаем обратно

    ALTER TABLE net.orders ENGINE=InnoDB;
    Query OK, 5 rows affected (0.18 sec)
    Records: 5  Duplicates: 0  Warnings: 0
    13 | 0.18191200 | ALTER TABLE net.orders ENGINE=InnoDB
## 4.

    [mysqld]
    pid-file        = /var/run/mysqld/mysqld.pid
    socket          = /var/run/mysqld/mysqld.sock
    datadir         = /var/lib/mysql
    secure-file-priv= NULL
    # размер лога операций
    innodb_log_file_size = 100M
    # тут надо указать 30% от доступной оперативной платы
    innodb_buffer_pool_size = 2048M
    #  хранить данные таблиц в отдельных файлах ibd*
    innodb_file_per_table=1
    # Этот параметр используется для установки информации о сохраненном каталоге данных InnoDB 
    innodb_additional_mem_pool_size = 16M
    innodb_buffer_pool_instances=16
    innodb_buffer_pool_chunk_size=1
    innodb_io_capacity= 1000
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    