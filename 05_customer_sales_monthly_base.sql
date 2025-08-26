-- Translate product category names to English

-- Purpose:
-- 1. Join product category translation table with products dataset to map product_id to English category names for subsequent analysis.
-- 2. Only product_id and the translated category name are retained.
-- 3. No DISTINCT used as both tables have unique records with no duplicates.

CREATE TABLE olist_product_category AS
SELECT op.product_id, pc.product_category_name_english AS product_category_name
FROM olist_products_dataset op
JOIN product_category_name_translation pc USING (product_category_name);

SELECT *
FROM olist_product_category;


-- Customer-Product Distribution Analysis Base Table

-- Purpose:
-- 1. Build a detailed base table at the customer and product category level with discrete time granularity by year and month.
-- 2. Aggregate key metrics including purchase frequency, purchase quantity, and payment amounts.
-- 3. Support analysis of customer purchasing behavior across different product categories and geographic locations.

-- Background:
-- 1. Only orders with status 'delivered' are included, ensuring valid completed transactions.
-- 2. Payment values reflect actual amounts paid by customers, capturing installment payments and adjustments.
-- 3. Each record corresponds to a unique combination of customer and product category, year, and month, enabling fine-grained behavioral insights.

-- Key Points:
-- 1. Frequency represents the number of distinct delivered orders per customer-product category.
-- 2. The purchase quantity reflects the total number of items purchased within each customer-product category group.
-- 3. Monetary metrics capture the total actual payment amount made by customers for a specific product category.
-- 4. Geographic information includes customer zip code, city, and state to enable detailed spatial analysis.
-- 5. Time dimension is discrete (aggregated by year and month), suitable for monthly trend analysis.

-- Outcome:
-- 1. Provides a comprehensive view of how individual customers distribute their purchases across product categories and regions.
-- 2. Facilitates targeted customer segmentation, product preference analysis, and regional marketing strategies.

CREATE TABLE customer_sales_monthly_base AS
SELECT
	c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    'Brazil' AS country,
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
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
	YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    pc.product_id,
    pc.product_category_name
ORDER BY c.customer_unique_id, order_year, order_month;

SELECT *
FROM customer_sales_monthly_base; 