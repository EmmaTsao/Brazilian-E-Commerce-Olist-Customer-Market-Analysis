USE olist_dataset;

-- Data Quality Check: Null & Irregular Value Verification Across All Tables

-- Purpose:
-- 1. Ensure that critical fields in each table do not contain null or invalid entries.
-- 2. Identify potential data quality issues that may impact subsequent analysis.

-- Background:
-- 1. Some fields (e.g., freight_value, payment_value) may appear null or zero due to business logic (e.g., free shipping, voucher payments), not actual data loss.
-- 2. This check also includes logical validations (e.g., zero values in quantity or price fields).

-- Analytical Implication:
-- 1. Fields with data issues are reviewed case by case.
-- 2. Some missing or zero values are accepted based on domain context and excluded from further cleaning.


-- olist_customers_dataset

SELECT 
    'olist_customers_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS customer_id_null_or_empty,
    SUM(CASE WHEN customer_unique_id IS NULL OR TRIM(customer_unique_id) = '' THEN 1 ELSE 0 END) AS customer_unique_id_null_or_empty,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL OR TRIM(customer_zip_code_prefix) = '' THEN 1 ELSE 0 END) AS zip_code_null_or_empty,
    SUM(CASE WHEN customer_city IS NULL OR TRIM(customer_city) = '' THEN 1 ELSE 0 END) AS city_null_or_empty,
    SUM(CASE WHEN customer_state IS NULL OR TRIM(customer_state) = '' THEN 1 ELSE 0 END) AS state_null_or_empty
FROM olist_customers_dataset;

-- olist_orders_dataset

SELECT
    'olist_orders_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS order_id_null_or_empty,
    SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS customer_id_null_or_empty,
    SUM(CASE WHEN order_status IS NULL OR TRIM(order_status) = '' THEN 1 ELSE 0 END) AS status_null_or_empty,
    SUM(CASE WHEN order_purchase_timestamp IS NULL OR TRIM(order_purchase_timestamp) = '' THEN 1 ELSE 0 END) AS purchase_time_null
FROM olist_orders_dataset;

-- olist_order_items_dataset

SELECT
    'olist_order_items_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS order_id_null_or_empty,
    SUM(CASE WHEN order_item_id IS NULL OR TRIM(order_item_id) = '' THEN 1 ELSE 0 END) AS item_id_null,
    SUM(CASE WHEN product_id IS NULL OR TRIM(product_id) = '' THEN 1 ELSE 0 END) AS product_id_null_or_empty,
    SUM(CASE WHEN seller_id IS NULL OR TRIM(seller_id) = '' THEN 1 ELSE 0 END) AS seller_id_null_or_empty,
    SUM(CASE WHEN shipping_limit_date IS NULL OR TRIM(shipping_limit_date) = '' THEN 1 ELSE 0 END) AS ship_date_null,
    SUM(CASE WHEN price IS NULL OR price <= 0 THEN 1 ELSE 0 END) AS price_null_or_zero,
    SUM(CASE WHEN freight_value IS NULL OR freight_value <= 0 THEN 1 ELSE 0 END) AS freight_value_null_or_negative 
FROM olist_order_items_dataset;
	
    -- freight_value has 383 NULL entries. After checking, it was found that the freight charges for those entries were 0, which is presumed to be a free shipping promotion or offer, rather than missing data.

-- olist_order_payments_dataset

SELECT
    'olist_order_payments_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS order_id_null_or_empty,
    SUM(CASE WHEN payment_sequential IS NULL OR TRIM(payment_sequential) = '' THEN 1 ELSE 0 END) AS payment_seq_null,
    SUM(CASE WHEN payment_type IS NULL OR TRIM(payment_type) = '' THEN 1 ELSE 0 END) AS type_null_or_empty,
    SUM(CASE WHEN payment_installments IS NULL OR TRIM(payment_installments) = '' THEN 1 ELSE 0 END) AS installments_null,
    SUM(CASE WHEN payment_value IS NULL OR payment_value <= 0 THEN 1 ELSE 0 END) AS value_null_or_negative
FROM olist_order_payments_dataset;

	-- 9 records with payment_value = 0 have been confirmed as having the payment type ‘voucher’ or ‘not_defined’.
	-- Since these 9 records have a payment_value of 0, they do not affect amount-based calculations.
	-- Analyses involving payment_value totals will not exclude these records, while other metrics, such as transaction counts, use different calculation methods.

-- olist_order_reviews_dataset

SELECT
    'olist_order_reviews_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN review_id IS NULL OR TRIM(review_id) = '' THEN 1 ELSE 0 END) AS review_id_null_or_empty,
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS order_id_null_or_empty,
    SUM(CASE WHEN review_score IS NULL OR TRIM(review_score) = '' THEN 1 ELSE 0 END) AS review_score_null,
    SUM(CASE WHEN review_creation_date IS NULL OR TRIM(review_creation_date) = '' THEN 1 ELSE 0 END) AS creation_date_null,
    SUM(CASE WHEN review_answer_timestamp IS NULL OR TRIM(review_answer_timestamp) = '' THEN 1 ELSE 0 END) AS answer_time_null
FROM olist_order_reviews_dataset;

-- olist_products_dataset

SELECT
    'olist_products_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_id IS NULL OR TRIM(product_id) = '' THEN 1 ELSE 0 END) AS product_id_null_or_empty,
    SUM(CASE WHEN product_category_name IS NULL OR TRIM(product_category_name) = '' THEN 1 ELSE 0 END) AS category_null_or_empty,
    SUM(CASE WHEN product_name_lenght IS NULL OR product_name_lenght <= 0 THEN 1 ELSE 0 END) AS name_length_null_or_zero,
    SUM(CASE WHEN product_description_lenght IS NULL OR product_description_lenght <= 0 THEN 1 ELSE 0 END) AS desc_length_null_or_zero,
    SUM(CASE WHEN product_photos_qty IS NULL OR product_photos_qty <= 0 THEN 1 ELSE 0 END) AS photo_qty_null_or_zero,
    SUM(CASE WHEN product_weight_g IS NULL OR product_weight_g <= 0 THEN 1 ELSE 0 END) AS weight_null_or_zero
FROM olist_products_dataset;

	-- 4 entries in product_weight_g are 0; as product specifications are not relevant to the subsequent analysis scope, these can be ignored from further validation.

-- olist_sellers_dataset

SELECT
    'olist_sellers_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL OR TRIM(seller_id) = '' THEN 1 ELSE 0 END) AS seller_id_null_or_empty,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL OR TRIM(seller_zip_code_prefix) = '' THEN 1 ELSE 0 END) AS zip_code_null_or_empty,
    SUM(CASE WHEN seller_city IS NULL OR TRIM(seller_city) = '' THEN 1 ELSE 0 END) AS city_null_or_empty,
    SUM(CASE WHEN seller_state IS NULL OR TRIM(seller_state) = '' THEN 1 ELSE 0 END) AS state_null_or_empty
FROM olist_sellers_dataset;

-- olist_geolocation_dataset

SELECT
    'olist_geolocation_dataset' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL OR TRIM(geolocation_zip_code_prefix) = '' THEN 1 ELSE 0 END) AS zip_code_null,
    SUM(CASE WHEN geolocation_lat IS NULL OR TRIM(geolocation_lat) = '' THEN 1 ELSE 0 END) AS lat_null,
    SUM(CASE WHEN geolocation_lng IS NULL OR TRIM(geolocation_lng) = '' THEN 1 ELSE 0 END) AS lng_null,
    SUM(CASE WHEN geolocation_city IS NULL OR TRIM(geolocation_city) = '' THEN 1 ELSE 0 END) AS city_null_or_empty,
    SUM(CASE WHEN geolocation_state IS NULL OR TRIM(geolocation_state) = '' THEN 1 ELSE 0 END) AS state_null_or_empty
FROM olist_geolocation_dataset;

-- product_category_name_translation

SELECT
    'product_category_name_translation' AS table_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL OR TRIM(product_category_name) = '' THEN 1 ELSE 0 END) AS category_name_null_or_empty,
    SUM(CASE WHEN product_category_name_english IS NULL OR TRIM(product_category_name_english) = '' THEN 1 ELSE 0 END) AS category_name_eng_null_or_empty
FROM product_category_name_translation;
