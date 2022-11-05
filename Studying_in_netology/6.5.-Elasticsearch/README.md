# 6.5. Elasticsearch
## 1.
 Я создал 2 файла [Dockerfile](./Dockerfile) и [docker-compose.yml](./docker-compose.yml) они оба во вложении. Так же я подготовил конфиг [elasticsearch.yml](/.conf/elasticsearch.yml)</br>
После чего я запустил контейнер.
Необходимо создать пользователя и дать ему права на папку с бинарным файлом</br>

        groupadd elasticsearch
        useradd elasticsearch -g elasticsearch -p elasticsearch
        cd /opt
        chown -R elasticsearch:elasticsearch *elasticsearch
        chmod o+x /root/ *elasticsearch/
        chgrp elasticsearch *elasticsearch
        su - elasticsearch
        cd *
        ./bin/elasticsearch
**Эти данные команды далее были добавлены в [докерфайл](./Dockerfile) в команду RUN*</br>
Далее пришлось помучаться с SSL сертификатом, оказалось что выше 8.0 проверка сертификата включена по умолчанию. 

Пришлось сбросить пароль для стандартного пользователя **elastic**

                ./bin/elasticsearch-reset-password -u elastic 

Далее проверяем и видим, что конфиг файл ***elasticsearch.yml*** не подтянулся

                curl --user elastic --insecure -X GET "https://localhost:9200/?pretty"              
                Enter host password for user 'elastic':
                {
                "name" : "55694371b0ae",
                "cluster_name" : "elasticsearch",
                "cluster_uuid" : "NjIZfH-tTLu2TwCGeA7lUA",
                "version" : {
                "number" : "8.2.2",
                "build_flavor" : "default",
                "build_type" : "tar",
                "build_hash" : "9876968ef3c745186b94fdabd4483e01499224ef",
                "build_date" : "2022-05-25T15:47:06.259735307Z",
                "build_snapshot" : false,
                "lucene_version" : "9.1.0",
                "minimum_wire_compatibility_version" : "7.17.0",
                "minimum_index_compatibility_version" : "7.0.0"
                },
                "tagline" : "You Know, for Search"
                }
*Оставлю это для потомков.*</br> Для исправления ситуации необходимо испавить elasticsearch.yml </br> и убрать полностью проверку security и пароля. </br>

        node.name: netology_test
        cluster.name: netology_test
        path.data: /var/lib/elasticsearch
        path.logs: /var/log/elasticsearch
        network.host: 127.0.0.1
        transport.host: 127.0.0.1
        http.host: 0.0.0.0
        http.port: 9200
        xpack.security.transport.ssl.enabled: false
        xpack.security.http.ssl.enabled: false
        xpack.security.authc.token.enabled: false
        xpack.security.enabled: false

В итоге получаем ответ по запросу 

        curl -XGET 'http://localhost:9200'
        {
        "name" : "netology_test",
        "cluster_name" : "netology_test",
        "cluster_uuid" : "ojsb1F4ARGWW_AvOVLfpiA",
        "version" : {
        "number" : "8.2.2",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "9876968ef3c745186b94fdabd4483e01499224ef",
        "build_date" : "2022-05-25T15:47:06.259735307Z",
        "build_snapshot" : false,
        "lucene_version" : "9.1.0",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
        },
        "tagline" : "You Know, for Search"
        }
## 2.
Добавляем в elasticsearch 3 индекса (пример 2 индекс)

        curl -XPUT "http://localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d '{ "settings": {"index": {"number_of_shards": 2, "number_of_replicas": 1 }}}'

                {
                "acknowledged" : true,
                "shards_acknowledged" : true,
                "index" : "ind-2"
                }

Проверка

         curl GET "http://localhost:9200/ind-2?pretty"

                curl: (6) Could not resolve host: GET
                {
                "ind-2" : {
                "aliases" : { },
                "mappings" : { },
                "settings" : {
                "index" : {
                        "routing" : {
                        "allocation" : {
                        "include" : {
                        "_tier_preference" : "data_content"
                        }
                        }
                        },
                        "number_of_shards" : "2",
                        "provided_name" : "ind-2",
                        "creation_date" : "1655106203466",
                        "number_of_replicas" : "1",
                        "uuid" : "hA-YVMjsQCio4_4cQFljWQ",
                        "version" : {
                        "created" : "8020299"
                        }
                }
                }
                }
                }

Получаем список индексов

                curl -k http://localhost:9200/_cat/indices\?v
                health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
                green  open   ind-1 gb2R2blQQhG12yEY_yYUNQ   1   0          0            0       225b           225b
                yellow open   ind-3 _pSPZKL3TLKkU1SDmUZ2Rw   4   2          0            0       900b           900b
                yellow open   ind-2 hA-YVMjsQCio4_4cQFljWQ   2   1          0            0       450b           450b

Получаем статус кластера *elasticsearch*

                curl http://127.0.0.1:9200/_cluster/health\?pretty
                {
                "cluster_name" : "netology_test",
                "status" : "yellow",
                "timed_out" : false,
                "number_of_nodes" : 1,
                "number_of_data_nodes" : 1,
                "active_primary_shards" : 8,
                "active_shards" : 8,
                "relocating_shards" : 0,
                "initializing_shards" : 0,
                "unassigned_shards" : 10,
                "delayed_unassigned_shards" : 0,
                "number_of_pending_tasks" : 0,
                "number_of_in_flight_fetch" : 0,
                "task_max_waiting_in_queue_millis" : 0,
                "active_shards_percent_as_number" : 44.44444444444444
                }

 Часть индексов и кластер находится в состоянии yellow, т.к у нас всего-лишь одна нода, и не куда реплицировать. 
 Удаляем индекса командой

         curl -XDELETE http://localhost:9200/ind-3
## 3.
Создаём директорию

                docker exec -it netology_test mkdir /usr/elastic/elasticsearch-8.2.2/bin/snapshots

        curl -XPUT 'http://localhost:9200/_snapshot/netology_backup' -H 'content-Type: application/json' -d '{"type": "fs", "settings": {"location": "/usr/elastic/elasticsearch-8.2.2/bin/snapshots", "compress":true}}' 
        {"acknowledged":true}%    

        curl -XPOST http://localhost:9200/_snapshot/netology_backup/_verify\?pretty
        {
        "nodes" : {
        "_Q7mJpcEToWEn0U_2p3TYw" : {
        "name" : "netology_test"
        }
        }
        }


        curl -k http://localhost:9200/_cat/indices\?v
        health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
        green  open   test  Snn2hAVzR4yJ9d0xPuf5kw   1   0          0            0       225b           225b

Сделать snapshot

        curl -XPUT 'http://localhost:9200/_snapshot/netology_backup/snapshot_all?wait_for_completion=true'       
        {"snapshot":{"snapshot":"snapshot_all","uuid":"ud7w0Z-MSCSdCqRrQsT1sA","repository":"netology_backup","version_id":8020299,"version":"8.2.2","indices":["test",".geoip_databases"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-06-13T13:30:36.614Z","start_time_in_millis":1655127036614,"end_time":"2022-06-13T13:30:38.016Z","end_time_in_millis":1655127038016,"duration_in_millis":1402,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}

Проверяем каталог со snapsot

        exec -it netology_test ls -lah /usr/elastic/elasticsearch-8.2.2/bin/snapshots        
                total 44K
                drwxr-xr-x 3 elasticsearch elasticsearch 4.0K Jun 13 13:30 .
                drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Jun 13 11:52 ..
                -rw-r--r-- 1 elasticsearch elasticsearch  845 Jun 13 13:30 index-0
                -rw-r--r-- 1 elasticsearch elasticsearch    8 Jun 13 13:30 index.latest
                drwxr-xr-x 4 elasticsearch elasticsearch 4.0K Jun 13 13:30 indices
                -rw-r--r-- 1 elasticsearch elasticsearch  19K Jun 13 13:30 meta-ud7w0Z-MSCSdCqRrQsT1sA.dat
                -rw-r--r-- 1 elasticsearch elasticsearch  352 Jun 13 13:30 snap-ud7w0Z-MSCSdCqRrQsT1sA.dat

        curl -XDELETE http://localhost:9200/test 
        {"acknowledged":true}% 
        curl -k http://localhost:9200/_cat/indices\?v
        health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
        green  open   test-2 -XBbRgpVQOuJeBNPUE5Gzg   1   0          0            0       225b           225b
производим восстановление индекса test

        curl -XPOST http://localhost:9200/_snapshot/netology_backup/snapshot_all/_restore -H 'content-Type: application/json' -d '{"indices": "test", "rename_pattern": "(.+)", "rename_replacement": "restored-$1"}'
        {"accepted":true}% 
Проверяем

        curl -k http://localhost:9200/_cat/indices\?v    

        health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
        green  open   test   4I_FENonTaKh6F-0QJEAQA   1   0          0            0       225b           225b
        green  open   test-2 -XBbRgpVQOuJeBNPUE5Gzg   1   0          0            0       225b          
Спасибо. 