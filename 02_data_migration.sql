-- ============================================
-- Data Migration from sales table
-- ============================================

-- Insert Customers
INSERT INTO customers (customer_id, signup_date, city)
SELECT 
    customer_id,
    MIN(order_date) AS signup_date,
    'Unknown'
FROM sales
GROUP BY customer_id;

-- Insert Products
INSERT INTO products (product_id, product_name, category, price)
SELECT 
    @rownum := @rownum + 1 AS product_id,
    product,
    category,
    AVG(price) AS price
FROM sales,
     (SELECT @rownum := 0) r
GROUP BY product, category;

-- Insert Orders
INSERT INTO orders (order_id, customer_id, order_date)
SELECT 
    order_id,
    customer_id,
    order_date
FROM sales;

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity)
SELECT 
    s.order_id,
    p.product_id,
    s.quantity
FROM sales s
JOIN products p 
    ON s.product = p.product_name
    AND s.category = p.category;