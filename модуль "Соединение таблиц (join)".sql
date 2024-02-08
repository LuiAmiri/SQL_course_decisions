/*Таблицы, к которым будут производиться запросы выглядят следующим образом:
  
  Таблица genre:
  +----------+-------------+
  | genre_id | name_genre  |
  +----------+-------------+
  | 1        | Роман       |
  | 2        | Поэзия      |
  | 3        | Приключения |
  +----------+-------------+
  
  Таблица author:
  +-----------+------------------+
  | author_id | name_author      |
  +-----------+------------------+
  | 1         | Булгаков М.А.    |
  | 2         | Достоевский Ф.М. |
  | 3         | Есенин С.А.      |
  | 4         | Пастернак Б.Л.   |
  | 5         | Лермонтов М.Ю.   |
  +-----------+------------------+
  
  Таблица book:
  +---------+-----------------------+-----------+----------+--------+--------+
  | book_id | title                 | author_id | genre_id | price  | amount |
  +---------+-----------------------+-----------+----------+--------+--------+
  | 1       | Мастер и Маргарита    | 1         | 1        | 670.99 | 3      |
  | 2       | Белая гвардия         | 1         | 1        | 540.50 | 5      |
  | 3       | Идиот                 | 2         | 1        | 460.00 | 10     |
  | 4       | Братья Карамазовы     | 2         | 1        | 799.01 | 3      |
  | 5       | Игрок                 | 2         | 1        | 480.50 | 10     |
  | 6       | Стихотворения и поэмы | 3         | 2        | 650.00 | 15     |
  | 7       | Черный человек        | 3         | 2        | 570.20 | 6      |
  | 8       | Лирика                | 4         | 2        | 518.99 | 2      |
  +---------+-----------------------+-----------+----------+--------+--------+*/

--Задание 1: Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
--Запрос:
  SELECT 
    title, 
    name_genre, 
    price
  FROM
      book INNER JOIN genre
      ON book.genre_id = genre.genre_id
  WHERE amount > 8
  ORDER BY price DESC
  ;

--Задание 2: Вывести все жанры, которые не представлены в книгах на складе.
--Запрос:
  SELECT name_genre
  FROM
      genre LEFT JOIN book
      ON genre.genre_id = book.genre_id
  WHERE book.genre_id IS NULL
  ;

--Задание 3:  Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
--Запрос:
  SELECT 
    name_genre, 
    title, 
    name_author
  FROM
      genre
      INNER JOIN book ON genre.genre_id = book.genre_id
      INNER JOIN author ON book.author_id = author.author_id
  WHERE name_genre LIKE('%роман%') 
  ORDER BY title
  ;

/*Задание 4: Посчитать количество экземпляров  книг каждого автора из таблицы author. 
Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.*/
--Запрос:
  SELECT 
    name_author, 
    SUM(amount) AS Количество
  FROM
      author LEFT JOIN book
      ON author.author_id = book.author_id
  GROUP BY name_author
  HAVING Количество < 10 OR COUNT(title) = 0
  ORDER BY Количество
  ;

/*Задание 5:  Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные,
что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book.
Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).*/
--Запрос:
  SELECT name_author
  FROM
      (SELECT 
        author_id, 
        COUNT(DISTINCT genre_id)
       FROM book
       GROUP BY author_id
       HAVING COUNT(DISTINCT genre_id) = 1
      ) need_genre
      LEFT JOIN
       author
      ON author.author_id = need_genre.author_id
  ORDER BY name_author
  ;

/*Задание 6:  Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книг),
написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.*/
--Запрос:
  SELECT title, name_author, name_genre, price, amount
  FROM
      book
      LEFT JOIN author ON author.author_id = book.author_id
      LEFT JOIN genre ON genre.genre_id = book.genre_id
  GROUP BY name_author, name_genre, title, price, amount, genre.genre_id
  HAVING genre.genre_id IN (SELECT firstt.genre_id FROM              
                                                      (SELECT genre_id, SUM(amount) f1
                                                       FROM book
                                                       GROUP BY genre_id
                                                      ) firstt
                                                      INNER JOIN
                                                      (SELECT genre_id, SUM(amount) f2
                                                       FROM book
                                                       GROUP BY genre_id
                                                       ORDER BY SUM(amount) DESC
                                                       LIMIT 1
                                                      ) two
                                                      ON firstt.f1 = two.f2
                            )
  ORDER BY title
  ;

/*Таблица supply:
  +-----------+----------------+------------------+--------+--------+
  | supply_id | title          | author           | price  | amount |
  +-----------+----------------+------------------+--------+--------+
  | 1         | Доктор Живаго  | Пастернак Б.Л.   | 618.99 | 3      |
  | 2         | Черный человек | Есенин С.А.      | 570.20 | 6      |
  | 3         | Евгений Онегин | Пушкин А.С.      | 440.80 | 5      |
  | 4         | Идиот          | Достоевский Ф.М. | 360.80 | 3      |
  +-----------+----------------+------------------+--------+--------+*/
/*Задание 7:  Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора,
а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.*/
--Запрос:
  SELECT 
    book.title AS Название, 
    author.name_author AS Автор, 
    SUM(supply.amount)+SUM(book.amount) AS Количество
  FROM
      author INNER JOIN book
      ON author.author_id = book.author_id
      INNER JOIN supply
      ON supply.title = book.title
      AND supply.price = book.price
      AND supply.author = author.name_author
  GROUP BY book.title, author.name_author
  ;

/*Задание 8: Для каждого автора из таблицы author вывести количество книг, написанных им в каждом жанре.
Вывод: ФИО автора, жанр, количество. Отсортировать по фамилии, затем - по убыванию количества написанных книг.*/
--Запрос:
  SELECT 
    name_author, 
    name_genre, 
    COUNT(title) AS Количество
  FROM
      author
      CROSS JOIN genre
      LEFT JOIN book
      USING(author_id, genre_id)
  GROUP BY name_author, name_genre
  ORDER BY name_author, Количество
  ;
