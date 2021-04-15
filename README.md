# Тестовое задание zapp_test
Описание (здесь)[https://docs.google.com/document/d/1kef5Z8w5sW-wZqhRhYDDaUt4rAsFE505roNO57BIpLk]

## Правки
### БД
Добавил 1 колонку - "uid" для хранения уникального для Списка Цен значения бренд-артикул. В БД оно не должно быть уникальным, т.к. является уникальным для Списка.
### Индексы
С 3-мя файлами нет особого смысла индексировать какие-либо колонки кроме тех, что должны быть уникальны. Т.к. индексы отнимают пространство, и требует более долгого обслуживания со стороны PG.

Поэтому можно индексировать только одно нужное поле uid.
### Регистрозависимость
Нет нужды заморачиваться с pg ilike и запросами, если можно привести уникальную колонку в uppercase или downcase и стандартизировать ее хранение в БД.
### Удаление всех продуктов из БД
После обновления Списка нужно удалить объекты, которые исчезли из списка. Вариантов несколько:
- Удалять продукты из Списка. Т.к. обновление - это 2 операции с точки зрения БД, то проще запустить 1 операцию по всем файлам. Долго (около 1 секунды для 1000 строк), но работает надежно;
- Следить за updated_at/created_at и удалять те, которые не были изменены после последнего импорта - надежнее, но требует большого кол-ва логики, проверок и тестов. Не факт, что окажется быстрее, т.к. еще нужно будет пробегать по таблице, вытаскивать значения записей, и удалять их.
## Что можно улучшить?
- Перед удалением товаров из Списка Цен, сначала проверить файл на наличие ошибок (сейчас они обрабатываются после);
- Парсить headers (оглавление) динамически, если известен словарь названий колонок;
- Парсить разделитель и кодировку автоматически;
- Вытащить обработку в sidekiq с последующим уведомлением через action cable или на почту/слэк;
- Создать подробную статистику - какие записи не попали и их строки;
- Нормализировать БД - не хранить значение Списка в колонке, а создать relation belongs_to. Для 10 миллионов строк получится много пространства, которое занимается впустую;
- Продумать лучшую версию проверки на уникальность UID (сейчас это минимум 0,4 мс на проверку). Можно, конечно, собирать массив уникальных значений и прогонять include?, но это 2 операции  - нужны дополнительные проверки.
