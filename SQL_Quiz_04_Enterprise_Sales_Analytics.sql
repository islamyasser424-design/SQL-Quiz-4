-- =============================================================================
-- SQL QUIZ 04: ENTERPRISE SALES ANALYTICS & DIMENSIONAL MODELING
-- 5-Table Fact/Dimension Star Schema, Subqueries & Window Functions
-- Author: Islam Yasser (Data Analyst & BI Specialist)
-- Target RDBMS: MySQL 8.0+
-- Database: Sales_Quiz
-- =============================================================================

DROP DATABASE IF EXISTS Sales_Quiz;
CREATE DATABASE Sales_Quiz
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE Sales_Quiz;


-- ==========================================================
-- 1. CUSTOMERS
-- ==========================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    city VARCHAR(50),
    signup_date DATE
);


-- ==========================================================
-- 2. CATEGORIES
-- ==========================================================

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(80) NOT NULL
);


-- ==========================================================
-- 3. PRODUCTS
-- ==========================================================

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(120) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    
    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


-- ==========================================================
-- 4. EMPLOYEES
-- ==========================================================

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    department VARCHAR(80)
);


-- ==========================================================
-- 5. SALES — FACT TABLE
-- ==========================================================

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    employee_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    payment_method ENUM('Cash', 'Credit Card', 'Wallet') NOT NULL,
    
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
        
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
        
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);


-- ==========================================================
-- INSERT CATEGORIES
-- ==========================================================

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books'),
('Home & Garden'),
('Sports');


-- ==========================================================
-- INSERT CUSTOMERS
-- ==========================================================

INSERT INTO customers (full_name, email, city, signup_date) VALUES
('Ahmed Ali', 'ahmed@mail.com', 'Cairo', '2023-01-15'),
('Sara Hassan', 'sara@mail.com', 'Alexandria', '2023-02-20'),
('Omar Saad', 'omar@mail.com', 'Giza', '2023-03-10'),
('Mona Khalil', 'mona@mail.com', 'Cairo', '2023-04-05'),
('Youssef Adel', 'youssef@mail.com', 'Mansoura', '2023-05-12'),
('Nour Fathy', 'nour@mail.com', 'Luxor', '2023-06-18'),
('Karim Samy', 'karim@mail.com', 'Cairo', '2023-07-22'),
('Hana Mostafa', 'hana@mail.com', 'Giza', '2023-08-30'),
('Mahmoud Tarek', 'mahmoud@mail.com', 'Alexandria', '2023-09-14'),
('Salma Nabil', 'salma@mail.com', 'Cairo', '2023-10-25'),
('Amr Hossam', 'amr@mail.com', 'Aswan', '2023-11-08'),
('Reem Ashraf', 'reem@mail.com', 'Giza', '2023-12-19'),
('Khaled Wael', 'khaled@mail.com', 'Cairo', '2024-01-07'),
('Mai Ahmed', 'mai@mail.com', 'Alexandria', '2024-02-11'),
('Tamer Said', 'tamer@mail.com', 'Cairo', '2024-03-16');


-- ==========================================================
-- INSERT PRODUCTS
-- ==========================================================

INSERT INTO products (product_name, price, category_id) VALUES
('Laptop Pro', 15000, 1),
('Wireless Mouse', 350, 1),
('Mechanical Keyboard', 1200, 1),
('Smartphone X', 9500, 1),
('USB-C Hub', 700, 1),

('T-Shirt Basic', 250, 2),
('Jeans Classic', 750, 2),
('Hoodie Premium', 900, 2),
('Running Shoes', 1800, 2),
('Jacket Winter', 1600, 2),

('MySQL Mastery', 300, 3),
('Python for Data Analysis', 450, 3),
('Clean Code', 500, 3),
('Data Science Handbook', 650, 3),
('SQL Cookbook', 550, 3),

('Garden Hose', 180, 4),
('Office Chair', 2500, 4),
('LED Desk Lamp', 450, 4),
('Coffee Maker', 2200, 4),
('Storage Box', 300, 4),

('Football', 500, 5),
('Tennis Racket', 1400, 5),
('Yoga Mat', 350, 5),
('Dumbbells Set', 1200, 5),
('Basketball', 600, 5);


-- ==========================================================
-- INSERT EMPLOYEES
-- ==========================================================

INSERT INTO employees (employee_name, department) VALUES
('Mohamed Hassan', 'Sales'),
('Ali Mahmoud', 'Sales'),
('Heba Ahmed', 'Sales'),
('Mostafa Samir', 'Sales'),
('Dina Khaled', 'Sales');


-- ==========================================================
-- INSERT SALES
-- 120 RECORDS
-- ==========================================================

INSERT INTO sales
(customer_id, product_id, employee_id, sale_date, quantity, discount, payment_method)
VALUES

(1,1,1,'2024-01-03',1,0,'Credit Card'),
(2,2,2,'2024-01-04',2,5,'Cash'),
(3,6,3,'2024-01-05',3,0,'Wallet'),
(4,11,1,'2024-01-06',1,10,'Credit Card'),
(5,17,4,'2024-01-08',1,5,'Cash'),
(6,21,2,'2024-01-10',2,0,'Wallet'),
(7,3,3,'2024-01-12',1,0,'Credit Card'),
(8,7,5,'2024-01-14',2,10,'Cash'),
(9,12,1,'2024-01-15',1,5,'Wallet'),
(10,19,4,'2024-01-17',1,0,'Credit Card'),

(11,4,2,'2024-01-20',1,15,'Cash'),
(12,8,3,'2024-01-22',2,0,'Wallet'),
(13,14,5,'2024-01-24',1,5,'Credit Card'),
(14,22,1,'2024-01-25',1,10,'Cash'),
(15,5,4,'2024-01-27',2,0,'Wallet'),
(1,9,2,'2024-02-01',1,5,'Credit Card'),
(2,13,3,'2024-02-03',2,0,'Cash'),
(3,18,5,'2024-02-05',1,10,'Wallet'),
(4,23,1,'2024-02-07',3,0,'Credit Card'),
(5,15,4,'2024-02-09',1,5,'Cash'),

(6,1,2,'2024-02-11',1,10,'Wallet'),
(7,10,3,'2024-02-13',2,0,'Credit Card'),
(8,16,5,'2024-02-15',3,5,'Cash'),
(9,20,1,'2024-02-17',1,0,'Wallet'),
(10,24,4,'2024-02-20',1,10,'Credit Card'),
(11,2,2,'2024-02-22',3,0,'Cash'),
(12,6,3,'2024-02-24',2,5,'Wallet'),
(13,11,5,'2024-02-26',1,0,'Credit Card'),
(14,17,1,'2024-02-28',1,15,'Cash'),
(15,21,4,'2024-03-01',2,5,'Wallet'),

(1,3,2,'2024-03-03',2,0,'Credit Card'),
(2,7,3,'2024-03-05',1,10,'Cash'),
(3,12,5,'2024-03-07',2,0,'Wallet'),
(4,19,1,'2024-03-09',1,5,'Credit Card'),
(5,22,4,'2024-03-11',2,0,'Cash'),
(6,4,2,'2024-03-13',1,10,'Wallet'),
(7,8,3,'2024-03-15',1,5,'Credit Card'),
(8,14,5,'2024-03-17',2,0,'Cash'),
(9,24,1,'2024-03-19',1,10,'Wallet'),
(10,5,4,'2024-03-21',2,0,'Credit Card'),

(11,9,2,'2024-03-23',1,5,'Cash'),
(12,13,3,'2024-03-25',1,0,'Wallet'),
(13,16,5,'2024-03-27',2,10,'Credit Card'),
(14,20,1,'2024-03-29',3,0,'Cash'),
(15,1,4,'2024-04-01',1,5,'Wallet'),
(1,6,2,'2024-04-03',2,0,'Credit Card'),
(2,11,3,'2024-04-05',1,10,'Cash'),
(3,17,5,'2024-04-07',1,5,'Wallet'),
(4,21,1,'2024-04-09',2,0,'Credit Card'),
(5,3,4,'2024-04-11',1,15,'Cash'),

(6,7,2,'2024-04-13',2,5,'Wallet'),
(7,12,3,'2024-04-15',1,0,'Credit Card'),
(8,18,5,'2024-04-17',2,10,'Cash'),
(9,23,1,'2024-04-19',1,0,'Wallet'),
(10,15,4,'2024-04-21',2,5,'Credit Card'),
(11,2,2,'2024-04-23',4,0,'Cash'),
(12,8,3,'2024-04-25',1,10,'Wallet'),
(13,14,5,'2024-04-27',2,5,'Credit Card'),
(14,19,1,'2024-04-29',1,0,'Cash'),
(15,22,4,'2024-05-01',2,10,'Wallet'),

(1,4,2,'2024-05-03',1,5,'Credit Card'),
(2,9,3,'2024-05-05',2,0,'Cash'),
(3,13,5,'2024-05-07',1,10,'Wallet'),
(4,16,1,'2024-05-09',3,0,'Credit Card'),
(5,20,4,'2024-05-11',1,5,'Cash'),
(6,24,2,'2024-05-13',2,0,'Wallet'),
(7,5,3,'2024-05-15',1,10,'Credit Card'),
(8,10,5,'2024-05-17',2,5,'Cash'),
(9,17,1,'2024-05-19',1,0,'Wallet'),
(10,21,4,'2024-05-21',2,10,'Credit Card'),

(11,3,2,'2024-05-23',1,0,'Cash'),
(12,7,3,'2024-05-25',2,5,'Wallet'),
(13,11,5,'2024-05-27',1,10,'Credit Card'),
(14,18,1,'2024-05-29',2,0,'Cash'),
(15,23,4,'2024-06-01',1,5,'Wallet'),
(1,15,2,'2024-06-03',2,0,'Credit Card'),
(2,19,3,'2024-06-05',1,10,'Cash'),
(3,22,5,'2024-06-07',3,5,'Wallet'),
(4,2,1,'2024-06-09',2,0,'Credit Card'),
(5,6,4,'2024-06-11',1,10,'Cash'),

(6,14,2,'2024-06-13',1,5,'Wallet'),
(7,20,3,'2024-06-15',2,0,'Credit Card'),
(8,24,5,'2024-06-17',1,10,'Cash'),
(9,1,1,'2024-06-19',1,5,'Wallet'),
(10,8,4,'2024-06-21',2,0,'Credit Card'),
(11,12,2,'2024-06-23',1,10,'Cash'),
(12,16,3,'2024-06-25',2,5,'Wallet'),
(13,21,5,'2024-06-27',1,0,'Credit Card'),
(14,5,1,'2024-06-29',2,10,'Cash'),
(15,9,4,'2024-07-01',1,5,'Wallet'),

(1,13,2,'2024-07-03',2,0,'Credit Card'),
(2,17,3,'2024-07-05',1,10,'Cash'),
(3,23,5,'2024-07-07',2,5,'Wallet'),
(4,3,1,'2024-07-09',1,0,'Credit Card'),
(5,10,4,'2024-07-11',2,10,'Cash'),
(6,18,2,'2024-07-13',1,5,'Wallet'),
(7,22,3,'2024-07-15',3,0,'Credit Card'),
(8,6,5,'2024-07-17',2,10,'Cash'),
(9,11,1,'2024-07-19',1,5,'Wallet'),
(10,20,4,'2024-07-21',2,0,'Credit Card'),

(11,4,2,'2024-07-23',1,10,'Cash'),
(12,9,3,'2024-07-25',2,5,'Wallet'),
(13,15,5,'2024-07-27',1,0,'Credit Card'),
(14,24,1,'2024-07-29',2,10,'Cash'),
(15,7,4,'2024-08-01',1,5,'Wallet'),
(1,16,2,'2024-08-03',2,0,'Credit Card'),
(2,21,3,'2024-08-05',1,10,'Cash'),
(3,5,5,'2024-08-07',2,5,'Wallet'),
(4,12,1,'2024-08-09',1,0,'Credit Card'),
(5,19,4,'2024-08-11',2,10,'Cash'),

(6,23,2,'2024-08-13',1,5,'Wallet'),
(7,2,3,'2024-08-15',3,0,'Credit Card'),
(8,14,5,'2024-08-17',1,10,'Cash'),
(9,18,1,'2024-08-19',2,5,'Wallet'),
(10,22,4,'2024-08-21',1,0,'Credit Card'),
(11,6,2,'2024-08-23',2,10,'Cash'),
(12,10,3,'2024-08-25',1,5,'Wallet'),
(13,17,5,'2024-08-27',2,0,'Credit Card'),
(14,1,1,'2024-08-29',1,10,'Cash'),
(15,3,4,'2024-09-01',2,5,'Wallet');


-- ==========================================================
-- MYSQL QUIZ
-- ==========================================================
-- Database: Sales_Quiz
-- Total Questions: 15
-- ==========================================================


-- ----------------------------------------------------------
-- Q1
-- Display all customers who live in Cairo.
-- ----------------------------------------------------------
select * 
from customers
where city='Cairo';

-- ----------------------------------------------------------
-- Q2
-- Display all products with a price greater than 1000,
-- sorted from highest price to lowest price.
-- ----------------------------------------------------------
select * 
from products
where price >1000
order by price desc;

-- ----------------------------------------------------------
-- Q3
-- Display the total number of sales records,
-- the maximum quantity sold, and the minimum quantity sold.
-- ----------------------------------------------------------
select count(*) as total_sales , max(quantity) as maximum_quantity , min(quantity) as minimum_quantity
from sales ;

-- ----------------------------------------------------------
-- Q4
-- Calculate the total quantity sold for each product.
-- Display the product name and total quantity.
-- ----------------------------------------------------------
SELECT p.product_name, SUM(s.quantity) AS Total_Quantity
FROM sales s
join products p on p.product_id=s.product_id
GROUP BY p.product_name;

-- ----------------------------------------------------------
-- Q5
-- Display the average product price for each category.
-- Display the category name and average price.
-- ----------------------------------------------------------
SELECT cat.category_name , avg(p.price) as average_price
FROM products p
join categories cat on cat.category_id=p.category_id
GROUP BY cat.category_name;
-- ----------------------------------------------------------
-- Q6
-- Display all sales with:
-- customer name, product name, quantity, and sale date.
-- Use JOINs.
-- ----------------------------------------------------------
select c.full_name , p.product_name , s.quantity , s.sale_date
from sales s 
join products p on s.product_id=p.product_id
join customers c on s.customer_id=c.customer_id ;

-- ----------------------------------------------------------
-- Q7
-- Display the total sales value for each product.
--
-- Sales Value = price * quantity
-- Display product name and total sales value.
-- ----------------------------------------------------------
select p.product_name , sum(p.price * s.quantity) as total_sales
from sales s 
join products p on s.product_id=p.product_id 
group by product_name;
-- ----------------------------------------------------------
-- Q8
-- Display each customer's name and the total amount
-- they have spent.
--
-- Total Amount = price * quantity
-- ----------------------------------------------------------
select c.full_name , sum(p.price* s.quantity) as Total_Amount
from sales s
join products p on s.product_id=p.product_id 
join customers c on s.customer_id=c.customer_id 
group by c.full_name;
-- ----------------------------------------------------------
-- Q9
-- Display the categories whose total sales value
-- is greater than 20,000.
-- ----------------------------------------------------------
SELECT cat.category_name, SUM(p.price * s.quantity) AS Total_Sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
HAVING SUM(p.price * s.quantity) > 20000;

-- ----------------------------------------------------------
-- Q10
-- Display the employee name and the total number
-- of sales handled by each employee.
-- ----------------------------------------------------------
SELECT e.employee_name, COUNT(s.sale_id) AS Total_Sales_Handled
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_name;

-- ----------------------------------------------------------
-- Q11
-- Display the product(s) whose price is higher than
-- the average price of all products.
--
-- Use a Subquery.
-- ----------------------------------------------------------
SELECT product_name, price
FROM products
WHERE price > (
SELECT AVG(price) 
    FROM products);

-- ----------------------------------------------------------
-- Q12
-- Display all customers who have made at least one sale.
--
-- Use IN with a Subquery.
-- ----------------------------------------------------------
SELECT *
FROM customers
WHERE customer_id IN (
SELECT customer_id 
FROM sales
);

-- ----------------------------------------------------------
-- Q13
-- Display the customer(s) who purchased the most expensive
-- product.
--
-- Use a Subquery.
-- ----------------------------------------------------------
SELECT DISTINCT c.full_name
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE p.price = (
SELECT MAX(price) 
FROM products
);

-- ----------------------------------------------------------
-- Q14
-- Display the top 3 most expensive products using
-- a Window Function.
--
-- Use RANK() or ROW_NUMBER().
-- ----------------------------------------------------------
SELECT product_name, price
FROM (
SELECT product_name, price, 
RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products
) AS ranked_products
WHERE price_rank <= 3;

-- ----------------------------------------------------------
-- Q15
-- Display each sale with:
-- customer name, sale date, quantity,
-- and the total quantity purchased by that customer.
--
-- Use a Window Function.
-- ----------------------------------------------------------
SELECT c.full_name,s.sale_date,s.quantity,SUM(s.quantity) 
OVER (PARTITION BY c.customer_id) AS Total_Customer_Quantity
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id;