--Задание 1: Создать таблицу author
--Запрос: 
  CREATE TABLE author
      (
      author_id INT PRIMARY KEY AUTO_INCREMENT,
      name_author VARCHAR(50)
      )
  ;

--Задание 2: Заполнить таблицу author. В нее включить следующих авторов: Булгаков М.А., Достоевский Ф.М., Есенин С.А., Пастернак Б.Л.
--Запрос:
  INSERT INTO author (name_author)
  VALUES
      ('Булгаков М.А.'),
      ('Достоевский Ф.М.'),
      ('Есенин С.А.'),
      ('Пастернак Б.Л.')
  ;

/*Задание 3: Перепишите запрос на создание таблицы book , чтобы ее структура соответствовала структуре, показанной на логической схеме.
Для genre_id ограничение о недопустимости пустых значений не задавать.*/ 
--Запрос:
  CREATE TABLE book
      (book_id INT PRIMARY KEY AUTO_INCREMENT,
       title VARCHAR(50),
       author_id INT NOT NULL,
       genre_id INT,
       price DECIMAL(8, 2),
       amount INT,
       FOREIGN KEY (author_id) REFERENCES author (author_id),
       FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
       )
  ;

/*Задание 4: Создать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, что при удалении автора из таблицы author
должны удаляться все записи о книгах из таблицы book, написанные этим автором. А при удалении жанра из таблицы genre для соответствующей записи book установить значение Null в столбце genre_id.*/
--Запрос:
  CREATE TABLE book
      (book_id INT PRIMARY KEY AUTO_INCREMENT,
       title VARCHAR(50),
       author_id INT NOT NULL,
       genre_id INT,
       price DECIMAL(8, 2),
       amount INT,
       FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
       FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
       )
  ;

--Задание 5: Добавьте три последние записи (с ключевыми значениями 6, 7, 8) в таблицу book
--Запрос:
  INSERT INTO book(title, author_id, genre_id, price, amount)
  VALUES
      ('Стихотворения и поэмы', 3, 2, 650.00, 15),
      ('Черный человек', 3, 2, 570.20, 6),
      ('Лирика', 4, 2, 518.99, 2)
  ;
