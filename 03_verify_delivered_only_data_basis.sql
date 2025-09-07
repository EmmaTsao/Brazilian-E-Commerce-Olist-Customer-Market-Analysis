-- Data validity verification: Order Status Analysis

-- Purpose:
-- 1. Summarize the number and proportion of orders by each status.
-- 2. Compare the total payment value and total product price plus freight value across statuses.
-- 3. Identify which order statuses should be included in subsequent customer and revenue analyses.

-- Background:
-- 1. In this dataset, only 'delivered' orders represent fully completed transactions, with both shipment fulfillment and actual payment received.
-- 2. Discrepancies between payment value and product value are expected in delivered orders, due to real-world business factors such as discounts, refunds, or installment payments.

-- Analytical Implication:
-- 1. Only 'delivered' orders will be retained for subsequent customers and revenue analysis, as they reflect genuine customer behavior and realized revenue.
-- 2. Excluding other statuses improves data reliability and aligns results with actual commercial outcomes.

-- Note:
-- 1. Non-delivered orders may contain payment or item data, but usually do not reflect finalized transactions or actual cash flow.
-- 2. Significant value differences (diffs) are only observed in 'delivered' orders, confirming their commercial completion.
-- 3. Although this verification includes freight value in the total order amount, subsequent customer and revenue analyses will exclude freight to focus on true product revenue.
-- 4. Including freight here helps quantify its impact and better understand differences between payment value and product charges.

 WITH order_item_sum AS (
	SELECT order_id, SUM(price + freight_value) AS total_price_freight
    FROM olist_order_items_dataset
    GROUP BY order_id
 ),
 payment_sum AS (
	SELECT order_id, SUM(payment_value) AS total_payment_value
    FROM olist_order_payments_dataset
    GROUP BY order_id
 )
 SELECT
	oo.order_status,
    COUNT(DISTINCT oo.order_id) AS order_count,
    ROUND(100.0 * COUNT(DISTINCT oo.order_id) / (SELECT COUNT(DISTINCT order_id) FROM olist_orders_dataset), 2) AS order_pct,
    ROUND(SUM(total_price_freight), 2) AS total_price_freight,
    ROUND(SUM(total_payment_value), 2) AS total_payment_value,
    ROUND(SUM(total_price_freight) - SUM(total_payment_value), 2) AS diff
 FROM olist_orders_dataset oo
 JOIN order_item_sum oi USING (order_id)
 JOIN payment_sum p USING (order_id)
 GROUP BY oo.order_status;
 
-- Result Interpretation:
-- 1. Delivered orders account for ~97% of all orders.
-- 2. Diff values in delivered orders reflect legitimate business activity such as discounts or promotions, confirming they are suitable for analysis focused on confirmed revenue and customer behavior.
