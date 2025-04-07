CREATE Table books (id SERIAL, title VARCHAR, author VARCHAR, price INT, stock INT, published_year DATE );

SELECT * FROM books;

INSERT INTO books (id, title, author, price, stock, published_year) VALUES (1, "The Pragmatic Programmer", "Andrew Hunt", 40, 10, 1999);