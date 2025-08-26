-- Customer-Product-Time Distribution Analysis Base Table

-- Purpose:
-- 1. Extend the customer-product level base table by incorporating a continuous daily time dimension.
-- 2. Aggregate key metrics, including purchase frequency, quantity, and payment amounts, over time.
-- 3. Support time-series analysis of customer purchasing behavior across product categories and geographic locations.

-- Background:
-- 1. Includes only 'delivered' orders to ensure valid completed transactions.
-- 2. Payment values reflect actual customer payments, including installments and adjustments.
-- 3. Each record corresponds to a unique combination of customer, product category, and order timestamp, enabling dynamic temporal insights.

-- Key Points:
-- 1. Aggregation is performed on a daily basis for each customer-product category pair.
-- 2. Compared to the non-temporal version, this table enables analysis of trends and seasonality over time.

-- Outcome:
-- 1. Enables comprehensive temporal analyses of customer preferences and spending patterns.
-- 2. Facilitates understanding of regional and product category sales evolution for targeted marketing and inventory planning.

CREATE TABLE customer_sales_daily_base AS
SELECT
	c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    'Brazil' AS country,
    DATE(o.order_purchase_timestamp) AS order_date,
    pc.product_id,
    pc.product_category_name,
    COUNT(DISTINCT oi.order_id) AS order_count,
    COUNT(oi.order_item_id) AS purchase_quantity,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value,
    ROUND(SUM(op.payment_value) / COUNT(DISTINCT oi.order_id), 2) AS avg_payment_per_order
FROM olist_customers_dataset c
JOIN olist_orders_dataset o USING (customer_id)
JOIN olist_order_items_dataset oi USING (order_id)
JOIN olist_product_category pc USING (product_id)
JOIN olist_order_payments_dataset op USING (order_id)
WHERE o.order_status = 'delivered'
GROUP BY
	c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp,
    pc.product_id,
    pc.product_category_name
ORDER BY c.customer_unique_id, order_date;
    
SELECT *
FROM customer_sales_daily_base;