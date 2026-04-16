CREATE DATABASE FreshMart;
USE FreshMart;

-- category table
CREATE TABLE Categories (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- product table
CREATE TABLE Products (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    category_id INT,
    stock INT,
    expiry DATE,
    price INT
);

-- sales transaction table
CREATE TABLE SalesTransactions (
    id INT PRIMARY KEY,
    product_id INT,
    qty INT,
    sale_date DATE
);

-- insert into category table
INSERT INTO Categories VALUES
(1, 'Milk Items'),
(2, 'Biscuits'),
(3, 'Drinks'),
(4, 'Fruits');

-- insert into product table
INSERT INTO Products VALUES
(1, 'Milk', 1, 60, '2026-04-20', 60),
(2, 'Curd', 1, 40, '2026-04-18', 30),
(3, 'ParleG', 2, 100, '2026-08-01', 10),
(4, 'Chips', 2, 90, '2026-07-01', 20),
(5, 'Cola', 3, 70, '2026-12-01', 90),
(6, 'Mango Drink', 3, 30, '2026-06-01', 40),
(7, 'Banana', 4, 120, '2026-04-19', 50),
(8, 'Apple', 4, 20, '2026-04-25', 100);

-- insert into sales transaction table
INSERT INTO SalesTransactions VALUES
(1, 1, 5, '2026-04-10'),
(2, 3, 10, '2026-03-15'),
(3, 4, 8, '2026-04-01'),
(4, 5, 6, '2026-03-20'),
(5, 7, 20, '2026-04-12');

-- expiring soon products
SELECT name, stock, expiry
FROM Products
WHERE expiry BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY
AND stock > 50;

-- dead stock products
SELECT p.name
FROM Products p
LEFT JOIN SalesTransactions s 
ON p.id = s.product_id 
AND s.sale_date >= CURDATE() - INTERVAL 60 DAY
WHERE s.product_id IS NULL;

-- revenue by category
SELECT c.name, SUM(p.price * s.qty) AS revenue
FROM SalesTransactions s
JOIN Products p ON s.product_id = p.id
JOIN Categories c ON p.category_id = c.id
WHERE MONTH(s.sale_date) = MONTH(CURDATE() - INTERVAL 1 MONTH)
GROUP BY c.name;