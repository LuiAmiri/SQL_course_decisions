--Задание 1: Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
--Запрос:
  CREATE TABLE supply
      (supply_id INT PRIMARY KEY AUTO_INCREMENT,
       title VARCHAR(50),
       author VARCHAR(30),
       price DECIMAL(8, 2),
       amount INT)
  ;

--Задание 2: Занесите в таблицу supply четыре записи:
--Запрос:
  INSERT INTO supply(supply_id, title, author, price, amount)
  VALUES 
      (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2),
      (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
      (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7),
      (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3)
  ;

--Задание 3: Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
--Запрос:
  INSERT INTO book(title, author, price, amount)
  SELECT
    title,
    author,
    price,
    amount
  FROM supply
  WHERE author NOT IN ('Булгаков М.А.','Достоевский Ф.М.')
  ;

/*Задание 4: Вложенным запросом отбираются все названия книг, которые есть в таблице book.
Основным запросом SELECT из таблицы supply выбираются книги, названия которых нет в результате вложенного запроса.
Отобранные записи добавляются в конец таблицы bookзапросом на добавление INSERT.*/
--Запрос:
  INSERT INTO book(title, author, price, amount)
  SELECT
    title,
    author,
    price,
    amount
  FROM supply
  WHERE author NOT IN (SELECT author FROM book)
  ;

--Задание 5: Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
--Запрос:
  UPDATE book
  SET price = 0.9*price
  WHERE amount BETWEEN 5 AND 10
  ;

/*Задание 6: В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг,
указанных в столбце amount. А цену тех книг, которые покупатель не заказывал, снизить на 10%.*/
--Запрос:
  UPDATE book
  SET
    buy = IF(amount - buy >= 0, buy, amount),
    price = IF(buy = 0, 0.9*price, price)
  ;

/*Задание 7: Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book
( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).*/
--Запрос:
  UPDATE book, supply
  SET book.amount = book.amount + supply.amount,
      book.price = (book.price + supply.price)/2
  WHERE book.author = supply.author AND book.title = supply.title
  ;

--Задание 8: Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
--Запрос:
  DELETE FROM supply
  WHERE author IN (SELECT author
                   FROM book
                   GROUP BY author
                   HAVING SUM(amount) > 10)
  ;

/*Задание 9: Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book.
В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.*/
--Запрос:
  CREATE TABLE ordering AS
  SELECT
    author,
    title,
    (SELECT ROUND(AVG(amount)) FROM book) AS amount
  FROM book
  WHERE title IN (SELECT title
                  FROM book
                  GROUP BY title
                  HAVING amount < (SELECT ROUND(AVG(amount)) FROM book)) 
  ;
