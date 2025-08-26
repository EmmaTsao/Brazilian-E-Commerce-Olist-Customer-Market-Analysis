-- Add a country column and set its value to 'Brazil' for geographic clarity

-- Purpose:
-- 1. Add a 'country' column to tables with location data.
-- 2. Set the 'country' value to 'Brazil' for all records.
-- 3. Improve geographic recognition and mapping accuracy in Tableau.

-- Note:
-- 1. ALTER TABLE adds the new column.
-- 2. UPDATE fills the column with 'Brazil'.
-- 3. SELECT verifies the update.

ALTER TABLE olist_customers_dataset ADD COLUMN country VARCHAR(50);
UPDATE olist_customers_dataset SET country = 'Brazil';
SELECT *
FROM olist_customers_dataset;

ALTER TABLE olist_geolocation_dataset ADD COLUMN country VARCHAR(50);
UPDATE olist_geolocation_dataset SET country = 'Brazil';
SELECT *
FROM olist_geolocation_dataset;