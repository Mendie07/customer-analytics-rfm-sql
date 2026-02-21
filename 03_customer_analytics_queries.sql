-- ============================================
-- Customer Analytics Queries
-- ============================================

-- Customer Lifetime Value
SELECT 
    c.customer_id,
    SUM(oi.quantity * p.price) AS lifetime_value
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC;


-- RFM Base
SELECT 
    c.customer_id,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(oi.quantity * p.price) AS monetary
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY c.customer_id;


-- Repeat Purchase Rate
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT customer_id) * 100, 2
    ) AS repeat_purchase_rate_percentage
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t;