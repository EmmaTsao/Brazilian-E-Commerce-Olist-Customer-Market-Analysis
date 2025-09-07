-- Data validity verification: Payment value vs. Product amount (product price plus freight)

-- Purpose:
-- 1. Compare payment value with product price plus freight to validate the appropriate metric for analysis.
-- 2. Support decision-making on which amount to use in subsequent customer and revenue analyses.

-- Background information:
-- 1. Payment value (MAX per order) reflects actual cash received, including installments or refunds.
-- 2. Product price plus freight represents the total charge to customers, including shipping fees.
-- 3. Differences arise due to business practices such as discounts, refunds, installments, and promotions.

-- Analytical implication:
-- 1. Payment value better captures customer payment behavior, making it suitable for customer analysis.
-- 2. Although product price excluding freight highlights pure sales revenue (as freight is an operational cost), 
--    payment value better reflects actual revenue, considering various payment scenarios.
-- 3. This query serves as a data validation step to help select the most appropriate metric.
-- 4. Subsequent analyses will consistently use payment value to ensure coherence.

-- Note:
-- 1. Freight is included here only to quantify its impact.
-- 2. This query is part of validation, not the main analysis.
-- 3. MAX(payment_value) is used to aggregate multiple payment records per order.

WITH order_payment_vs_items AS (
	SELECT
		op.order_id,
        MAX(op.payment_value) AS total_payment_value, -- Use MAX to capture full payment in case of installments
		SUM(oi.price + oi.freight_value) AS total_item_value
    FROM olist_order_payments_dataset op
	JOIN olist_order_items_dataset oi USING (order_id)
    GROUP BY op.order_id
)
SELECT
	COUNT(*) AS total_orders,
    SUM(CASE WHEN total_payment_value = total_item_value THEN 1 ELSE 0 END) AS orders_payment_equal,
    ROUND(100.0 * SUM(CASE WHEN total_payment_value = total_item_value THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_payment_equal,
    SUM(CASE WHEN total_payment_value > total_item_value THEN 1 ELSE 0 END) AS orders_payment_greater,
    ROUND(100.0 * SUM(CASE WHEN total_payment_value > total_item_value THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_payment_greater,
    SUM(CASE WHEN total_payment_value < total_item_value THEN 1 ELSE 0 END) AS orders_payment_less,
    ROUND(100.0 * SUM(CASE WHEN total_payment_value < total_item_value THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_payment_less,
    ROUND(AVG(total_payment_value - total_item_value), 2) AS avg_diff_amount
FROM order_payment_vs_items;

-- Result interpretation:
-- This summary quantifies how many orders have payment amounts equal to, higher than, or lower than the product price plus freight.
-- Understanding these proportions helps define which metric is more appropriate in subsequent customer and revenue analyses.
