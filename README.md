# Brazilian E-Commerce Olist Customer & Sales Analysis

## Project Overview
This project focuses on customer and market analysis of the Brazilian e-commerce platform Olist. It utilizes the RFM (Recency, Frequency, Monetary) model to assess customer value and categorizes states into three revenue tiers based on total payment value. Market segmentation is further refined by analyzing payment value, revenue growth rates, and trends from January 2017 to August 2018. The findings reveal customer behaviors and market status, providing actionable recommendations for business strategy.

## Data Source
- Dataset from Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data
- Data period: January 2017 - August 2018
- The original dataset covers 2016 to 2018, but the analysis excludes the 2016 data due to limited and skewed records concentrated in October.

## Tools & Method
- SQL for data cleaning and aggregation
- Tableau for data visualization
- Business analysis for actionable insights

## Key Findings
- The market experienced an overall growth of 153.2% in January-August 2018 compared to the same period in 2017.
- São Paulo (SP) state is the key market that contributes the most revenue and should be prioritized for retention efforts.
- Some states are classified as underperforming markets, showing stagnant growth and low purchasing power, highlighting the need to explore customer needs and monitor churn risks.
- The average purchase frequency per customer is nearly one transaction across all revenue tiers, reflecting generally low customer activity. Further investigation into customer purchasing behavior is recommended, but is beyond the scope of this project.

## How to Use
- SQL scripts are located in the `sql/` folder.
- Tableau link: [Brazilian E-Commerce Olist Customer & Sales Analysis](https://public.tableau.com/app/profile/emma.tsao/viz/Olist_customersalesanalysis_0816/Olist)

## Limitations & Future Work
- Customer information is limited, lacking key demographics such as gender, age, and occupation for deeper insights.
- Supply-side analysis is not included in this project.
- Future work could enhance the analysis by incorporating additional customer segmentation methods and deeper data attributes.

## Contact
Emma Tsao - tttxyunn@gmail.com
