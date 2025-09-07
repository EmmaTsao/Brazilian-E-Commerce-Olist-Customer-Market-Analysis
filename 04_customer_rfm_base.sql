-- Customer RFM Base Table Construction

-- Purpose:
-- 1. Construct a customer-level base table for RFM analysis.
-- 2. Aggregate recency, frequency, and monetary value for each customer.
-- 3. Provide foundational data for customer segmentation and further business analytics.

-- Background:
-- 1. The Olist database covers orders from 2016 to 2018. However, the 2016 data is highly skewed, with nearly all orders concentrated in October and only a single order each in September and December.
--    Because this skewness can introduce bias, all 2016 data is excluded directly from the RFM base to ensure accurate and reliable customer metric calculations.
-- 2. The 2018 data is incomplete, as it only includes orders from January to August; data for September through December is missing.
--    Despite the missing months, the volume of 2018 data is substantial, so all available records for 2018 are retained for analysis.
--    Readers should be aware of these time coverage limitations. In subsequent customer & revenue analyses, for monthly-level analysis, data will be processed separately by year, and appropriate period annotations will be added in visualizations and reports to avoid misleading interpretations.
-- 3. Only orders with status 'delivered' are included to ensure the analysis reflects completed and valid transactions, thereby improving data accuracy and reliability.

-- Key Points:
-- 1. Recency uses a fixed reference date to ensure consistency.
-- 2. Frequency counts the distinct delivered orders per customer.
-- 3. Monetary sums are actual payments per order.
-- 4. Maximum payment per order is used to accurately represent the actual total payment, accounting for multiple payment records such as installments or adjustments.

-- Outcome:
-- This base table provides reliable and accurate customer metrics for segmentation, behavioral analysis, and business intelligence.

SELECT MAX(order_purchase_timestamp)
FROM olist_orders_dataset
WHERE order_status = 'delivered' AND order_purchase_timestamp >= '2017-01-01';

-- The latest 'delivered' order's purchase date is 2018-08-29, which is used to calculate the recency.

CREATE TABLE customer_rfm_base AS
WITH payment_value_per_order AS (
	SELECT order_id, MAX(payment_value) AS act_payment_value
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT
	oc.customer_unique_id,
    oc.customer_zip_code_prefix,
    oc.customer_city,
    oc.customer_state,
    'Brazil' AS customer_country,
    DATEDIFF('2018-08-29', DATE(MAX(oo.order_purchase_timestamp))) AS recency,
    COUNT(DISTINCT oo.order_id) AS number_of_purchases,
    ROUND(SUM(p.act_payment_value), 2) AS total_payment_value,
    ROUND(SUM(p.act_payment_value) / COUNT(DISTINCT oo.order_id), 2) AS avg_payment_value_per_order
FROM olist_customers_dataset oc
JOIN olist_orders_dataset oo USING (customer_id)
JOIN payment_value_per_order p USING (order_id)
WHERE oo.order_status = 'delivered' AND oo.order_purchase_timestamp >= '2017-01-01'
GROUP BY
	oc.customer_unique_id,
	oc.customer_zip_code_prefix,
	oc.customer_city,
	oc.customer_state
ORDER BY
	oc.customer_unique_id,
    oc.customer_zip_code_prefix,
    oc.customer_city,
    oc.customer_state;

SELECT *
FROM customer_rfm_base
ORDER BY recency DESC;
