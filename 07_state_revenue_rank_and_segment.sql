-- Revenue Ranking and Segmentation Query Description

-- Purpose:
-- 1. Calculate a unique rank for each customer state within each country based on total payment value using the ROW_NUMBER() window function.
-- 2. Segment the states into revenue tiers: Top 20% (Core), Middle 60% (Stable/Potential), and Bottom 20% (Low) based on their rank, enabling targeted market analysis.
-- 3. Include the cumulative revenue percentage to understand the distribution and concentration of total payment value across states.
--
-- Background:
-- 1. Includes only orders with a status of 'delivered' to ensure that only completed transactions are counted.
-- 2. Filters out data from before 2017 to avoid the skewed 2016 data, where most transactions were concentrated in October with very few records in September and December.
-- 3. Aggregates total payment values by country and customer state by joining order, payment, and customer datasets.
-- 4. Uses window functions to calculate the rank, total number of states, running total payment, and total payment for a more detailed analysis.
--
-- Key Points:
-- 1. ROW_NUMBER() generates a unique rank for each customer state ordered by descending total payment value.
-- 2. COUNT() OVER () provides the total count of states to determine percentile boundaries for segmentation.
-- 3. SUM() OVER (ORDER BY ...) calculates the running total of payment values to derive the cumulative payment percentage.
-- 4. Revenue tiers are classified using CASE statements based on rank relative to the total number of states.
--
-- Outcome:
-- 1. Returns each country and state’s total payment value, rank, cumulative revenue percentage, running total payment, and assigned revenue tier.
-- 2. Facilitates granular analysis of revenue concentration and geographic performance.
-- 3. Supports strategic decision-making based on state-level revenue rankings and segmentation.

CREATE TABLE state_revenue_rank_and_segment AS
WITH ranking AS(
SELECT
	oc.country,
	oc.customer_state,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value,
    ROW_NUMBER() OVER (ORDER BY SUM(op.payment_value) DESC) AS state_rank,
    COUNT(*) OVER () AS total_states,
    ROUND(SUM(SUM(op.payment_value)) OVER (ORDER BY SUM(op.payment_value) DESC), 2) AS running_total_payment,
    ROUND(SUM(SUM(op.payment_value)) OVER (), 2) AS grand_total_payment
FROM olist_orders_dataset oo
JOIN olist_order_payments_dataset op USING (order_id)
JOIN olist_customers_dataset oc USING (customer_id)
WHERE oo.order_status = 'delivered' AND oo.order_purchase_timestamp >= '2017-01-01'
GROUP BY 
	oc.country,
    oc.customer_state
)
SELECT
	country,
    customer_state,
    total_payment_value,
    state_rank,
    ROUND(100.0 * running_total_payment / grand_total_payment, 2) AS cumulative_percentage,
    running_total_payment,
    CASE WHEN state_rank <= total_states * 0.2 THEN 'Top 20% (Core)'
         WHEN state_rank <= total_states * 0.8 THEN 'Middle 60% (Stable/Potential)'
         ELSE 'Bottom 20% (Low)' END AS revenue_tier
FROM ranking
ORDER BY state_rank;

SELECT *
FROM state_revenue_rank_and_segment;