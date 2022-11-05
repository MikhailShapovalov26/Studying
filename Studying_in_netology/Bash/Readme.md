# 4.1. Командная оболочка Bash: Практические навыки
## 1.
Допишем вывод сразу после действий сложение

        a=1
        b=2
        c=a+b
        echo $c
        d=$a+$b
        echo $d
        e=$(($a+$b))
        echo $e

По итогу получи 

c=a+b так как баш не передавал значения, а просто принял с как строковую переменую

d=1+2 далее мы использовали $ выражения переменных, мы подставили в наше предложение не символы а и b а их значения, то что мы выши положили. К примеру $USER выдаст результат кто авторизован. Но выражение осталось предложением. И по этому выражения подставились и остался знак + между ними. 

e=3 Тут мы использовали двойные круглые скобки, аналог команды let. И присвоили переменной е. Они((..)) вычислают арифимитеские выражения и возращают результат.
## 2.
        while ((1==1))
        do
                curl Адрес
                if (($? != 0))
                then
                        date >> curl.log
                else exit
                fi
                sleep 50
        done
## 3.
Вот сам скрипт

                #!/bin/bash
                >curl.log
                h=1
                ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")
                for i in {1..5}
                do
                for h in ${ips[@]}
                do
                        date >>curl.log
                curl -m1 $h:80>/dev/null &>>curl.log
                done
                done
Результат лог файла (приведу не целиком)

                Вт 15 мар 2022 09:40:02 MSK
                % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                Dload  Upload   Total   Spent    Left  Speed

                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
                curl: (28) Connection timed out after 1001 milliseconds
                Вт 15 мар 2022 09:40:04 MSK
                % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                Dload  Upload   Total   Spent    Left  Speed

                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                100   219  100   219    0     0   1280      0 --:--:-- --:--:-- --:--:--  1280
                <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
                <TITLE>301 Moved</TITLE></HEAD><BODY>
                <H1>301 Moved</H1>
                The document has moved
                <A HREF="http://www.google.com/">here</A>.
                </BODY></HTML>
                Вт 15 мар 2022 09:40:04 MSK
                % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                Dload  Upload   Total   Spent    Left  Speed

                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                Вт 15 мар 2022 09:40:04 MSK
                % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                Dload  Upload   Total   Spent    Left  Speed

                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
                curl: (28) Connection timed out after 1001 milliseconds
                Вт 15 мар 2022 09:40:05 MSK
                % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                                Dload  Upload   Total   Spent    Left  Speed

                0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
                100   219  100   219    0     0   1265      0 --:--:-- --:--:-- --:--:--  1265
                <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
                <TITLE>301 Moved</TITLE></HEAD><BODY>
                <H1>301 Moved</H1>
                The document has moved
                <A HREF="http://www.google.com/">here</A>.
                </BODY></HTML>
## 4.
                #!/bin/bash
                >curl.log
                >errorcurl.log
                h=1
                ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")
                while :
                do
                for h in ${ips[@]}
                do
                if timeout 2 bash -c "</dev/tcp/$h/80"
                        then
                                date +%x-%R >>curl.log
                                curl -m1 $h:80>/dev/null &>>curl.log
                        else
                                date +%x-%R >>errorcurl.log
                                curl -m1 $h:80>/dev/null &>>errorcurl.log
                                sleep 5
                                echo "Тест закончен" >> errorcurl.log
                                exit 0
                        fi
                done
                done
## 5. 
я пытался несколько дней решить данную проблему, всё что я смог сделать

                #!/usr/bin/env bash
                INPUT_FILE=$1
                START_LINE=`head -n1 $INPUT_FILE`
                PATTERN="^\[[0-9]\{2,4\} [а-яА-Я]\{2,10\} [0-9]\{2,4\}\] [а-яА-Я]\{2,10\} [а-яА-Я]\{2,10\}"
                if ! [[ "$START_LINE" =~ $PATTERN ]]; then
                echo "Bad commit message, see example: [04 задание 01] сломал хуки"
                exit 1
                fi
Тест комбинации

                echo '[04 задание 01] хук справа' |grep "^\[[0-9]\{2,4\} [а-яА-Я]\{2,10\} [0-9]\{2,4\}\] [а-яА-Я]\{2,10\} [а-яА-Я]\{2,10\}"
                [04 задание 01] хук справа
