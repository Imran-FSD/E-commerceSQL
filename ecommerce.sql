-- e-commerce database
CREATE DATABASE ecommerce;

-- created database
USE ecommerce;

-- customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(100) NOT NULL,        
    email VARCHAR(100) NOT NULL UNIQUE, 
    address VARCHAR(255) NOT NULL       
);

-- products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,       
    price DECIMAL(10, 2) NOT NULL,     
    description TEXT                  
);

-- orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,  
    customer_id INT NOT NULL,          
    order_date DATETIME NOT NULL,       
    total_amount DECIMAL(10, 2) NOT NULL, 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert customers table
INSERT INTO customers (name, email, address) VALUES
('Immu', 'immu@gmail.com', '94 sa'),
('Tam', 'tam@gmail.com', '56 chn'),
('Suda', 'suda@gmail.com', '66 krn');

-- Insert products table
INSERT INTO products (name, price, description) VALUES
('Product A', 30.00, 'Lap'),
('Product B', 20.00, 'Mouse'),
('Product C', 50.00, 'Keyboard');

-- Insert orders table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, NOW() - INTERVAL 10 DAY, 150.00),
(2, NOW() - INTERVAL 5 DAY, 75.00),
(1, NOW() - INTERVAL 40 DAY, 100.00),
(3, NOW() - INTERVAL 15 DAY, 200.00);

-- placed an order in the last 30 days
SELECT DISTINCT customers.*
FROM customers
JOIN orders ON customers.id = orders.customer_id
WHERE orders.order_date >= NOW() - INTERVAL 30 DAY;

-- total amount of all orders placed by each customer
SELECT customers.name, SUM(orders.total_amount) AS total_spent
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id;

-- Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- new column for discounts in the products table
ALTER TABLE products
ADD COLUMN discount DECIMAL(10, 2) DEFAULT 0.00;

-- top 3 products with the highest price
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

-- names of customers who ordered Product A
SELECT DISTINCT customers.name
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.name = 'Product A';

-- customer's name and order date for each order
SELECT customers.name, orders.order_date
FROM orders
JOIN customers ON orders.customer_id = customers.id;

-- orders with a total amount greater than 150.00
SELECT *
FROM orders
WHERE total_amount > 150.00;

-- new table for order items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    order_id INT NOT NULL,             
    product_id INT NOT NULL,          
    quantity INT NOT NULL,              
    FOREIGN KEY (order_id) REFERENCES orders(id), 
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample data for order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 1, 1);

-- total of all orders
SELECT AVG(total_amount) AS average_order_amount
FROM orders;
