CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    stock INTEGER CHECK (stock >= 0),
    published_year INTEGER
);

SELECT * FROM books;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

SELECT * FROM customers; --select customer all data

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    book_id INTEGER NOT NULL REFERENCES books(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);  -- create order table

INSERT INTO books (title, author, price, stock, published_year)
VALUES
    ('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
    ('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
    ('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
    ('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
    ('Database Design Principles', 'Jane Smith', 20.00, 0, 2018); -- insert books

SELECT * FROM books; -- select books

-- insert customer data: 

INSERT INTO customers (id, name, email, joined_date)
VALUES
    (1, 'Alice', 'alice@email.com', '2023-01-10'),
    (2, 'Bob', 'bob@email.com', '2022-05-15'),
    (3, 'Charlie', 'charlie@email.com', '2023-06-20'); -- insert customers

SELECT * FROM customers;

INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES (1, 1, 2, 1, '2024-03-10'), (2, 2, 2, 1, '2024-03-30'), (3, 3, 4, 3, '2024-04-30'); -- insert orders
INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES (4, 3, 4, 4, '2024-05-10'), (5, 3, 5, 3, '2024-05-20'); -- insert orders


SELECT * FROM orders ; -- select orders


-- Find books that are out of stock.

SELECT title
FROM books
WHERE stock = 0;

-- Retrieve the most expensive book in the store.

SELECT id, title, author, price, stock, published_year
FROM books
ORDER BY price DESC
LIMIT 2;

--Find the total number of orders placed by each customer.

SELECT 
    c.name,
    COUNT(o.id) AS total_orders -- count order table order id 
FROM 
    customers c -- customer table as short name c 
LEFT JOIN 
    orders o ON c.id = o.customer_id -- order table as short name o  
GROUP BY 
    c.id, c.name, c.email
ORDER BY 
    total_orders DESC; -- desending order of total order. example 3 2 1

-- Calculate the total revenue generated from book sales.

SELECT 
    SUM(b.price * o.quantity) AS total_revenue
FROM 
    orders o
JOIN 
    books b ON o.book_id = b.id;


-- List all customers who have placed more than one order.

SELECT
    c.name,
    c.email,
    COUNT(o.id) AS orders_count
FROM 
    customers c
JOIN 
    orders o ON c.id = o.customer_id
GROUP BY 
    c.id, c.name, c.email
HAVING 
    COUNT(o.id) > 1
ORDER BY 
    orders_count DESC;

-- Find the average price of books in the store.

SELECT 
    ROUND(AVG(price), 2) AS avg_book_price
FROM 
    books;

--Increase the price of all books published before 2000 by 10%.


SELECT id, title, author, price, stock, published_year
FROM books
ORDER BY id;

--price update:
UPDATE books
SET price = ROUND(price * 1.10, 2)
WHERE published_year < 2000;

--verify all books with their new prices:

SELECT * FROM books ORDER BY id;


--Delete customers who haven't placed any orders.

SELECT c.id, c.name, c.email
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- Execute deletion
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);

SELECT id, name, email, joined_date
FROM customers
ORDER BY id;

SELECT * FROM customers 
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- Verify remaining customers
SELECT * FROM customers ORDER BY id;
