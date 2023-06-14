# Резервное копирование
## Домашнее задание. Горбунов Владимир

## Цель задания
1. Настраивать регулярные задачи на резервное копирование (полная зеркальная копия)
2. Настраивать инкрементное резервное копирование с помощью rsync

## Содержание

- [Задание 1. Rsync. Зеркальная копия с проверкой хэшей](#Задание-1)
- [Задание 2. Rsync + cron](#Задание-2)  
- [Задание 3. HAProxy + nginx + simple python server](#Задание-3) 
- [Задание 4. HAProxy. Два бекэнда, simple python server](#Задание-4)  


## Задание 1
> Составьте команду rsync, которая позволяет создавать зеркальную копию домашней директории пользователя в директорию `/tmp/backup` </br>
Необходимо исключить из синхронизации все директории, начинающиеся с точки (скрытые)</br>
Необходимо сделать так, чтобы rsync подсчитывал хэш-суммы для всех файлов, даже если их время модификации и размер идентичны в источнике и приемнике.</br>
На проверку направить скриншот с командой и результатом ее выполнения</br>

Text.


![](./img/task1.jpg)



## Задание 2
> Написать скрипт и настроить задачу на регулярное резервное копирование домашней директории пользователя с помощью rsync и cron.</br>
Резервная копия должна быть полностью зеркальной</br>
Резервная копия должна создаваться раз в день, в системном логе должна появляться запись об успешном или неуспешном выполнении операции</br>
Резервная копия размещается локально, в директории `/tmp/backup`</br>
На проверку направить файл crontab и скриншот с результатом работы утилиты.

Text

[file](./file)

![](./img/task2.jpg)


## Задание 3

> Настройте ограничение на используемую пропускную способность rsync до 1 Мбит/c </br>
Проверьте настройку, синхронизируя большой файл между двумя серверами</br>
На проверку направьте команду и результат ее выполнения в виде скриншота

text

![](./img/task3.jpg)


## Задание 4
> Напишите скрипт, который будет производить инкрементное резервное копирование домашней директории пользователя с помощью rsync на другой сервер </br>
Скрипт должен удалять старые резервные копии (сохранять только последние 5 штук) </br>
Напишите скрипт управления резервными копиями, в нем можно выбрать резервную копию и данные восстановятся к состоянию на момент создания данной резервной копии.</br>
На проверку направьте скрипт и скриншоты, демонстрирующие его работу в различных сценариях.

text

![](./img/task4.jpg)