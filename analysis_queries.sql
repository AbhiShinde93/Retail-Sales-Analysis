SELECT * FROM superstore
LIMIT 10;
--Sales Performance
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'superstore'
ORDER BY ordinal_position;
--Q1. Which state generates the highest revenue?
SELECT state , 
SUM(sales) as total_revenue
from superstore
GROUP BY state 
ORDER BY total_revenue DESC;



--Q2. Which city generates the highest sales?
SELECT
    city,
    ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM superstore
GROUP BY city
ORDER BY total_sales DESC


--Q3. Which region contributes the highest revenue?
SELECT
    region,
    ROUND(SUM(sales):: numeric, 2) AS total_revenue
FROM superstore
GROUP BY region
ORDER BY total_revenue DESC;
--Q4. Which year generated the highest sales?
SELECT
    year,
    ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM superstore
GROUP BY year
ORDER BY total_sales DESC;

--Q5. Which month generated the highest revenue?
SELECT
    month,
    ROUND(SUM(sales)::numeric,2) AS total_revenue
FROM superstore
GROUP BY month
ORDER BY total_revenue DESC;
--Q6. Which quarter generated the highest sales?
SELECT
    quarter,
    ROUND(SUM(sales)::numeric,2) AS total_sales
FROM superstore
GROUP BY quarter
ORDER BY total_sales DESC;
--Q7. How do monthly sales trends change across different years?
SELECT
    year,
    month,
    ROUND(SUM(sales)::numeric,2) AS total_sales
FROM superstore
GROUP BY year, month_no, month
ORDER BY year, month_no;
--Customer Analysis

--Q8. Which city has the highest number of unique customers?
SELECT
    city,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore
GROUP BY city
ORDER BY unique_customers DESC;

--Q9. Which customer segment (New, Returning, Loyal) generates the highest revenue?
SELECT
    customer_segment,
    ROUND(SUM(sales)::numeric,2) AS total_revenue
FROM superstore
GROUP BY customer_segment
ORDER BY total_revenue DESC;
--Q10. Which customer segment generates the highest profit?
SELECT
    customer_segment,
    ROUND(SUM(profit)::numeric,2) AS total_profit
FROM superstore
GROUP BY customer_segment
ORDER BY total_profit DESC;
--Q11. Which customer segment places the most orders?
SELECT
    customer_segment,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_segment
ORDER BY total_orders DESC;
--Q12. Which customer segment has the highest average order value?
SELECT
    customer_segment,
    ROUND(
        (SUM(sales) / COUNT(DISTINCT order_id))::numeric,
        2
    ) AS average_order_value
FROM superstore
GROUP BY customer_segment
ORDER BY average_order_value DESC;
--Shipping & Operations

--Q13. What is the average delivery time?
SELECT
    ROUND(AVG(delivery_days)::numeric,2) AS average_delivery_days
FROM superstore;
--Q14. Which shipping mode generates the highest sales?
SELECT
    ship_mode,
    ROUND(SUM(sales)::numeric,2) AS total_sales
FROM superstore
GROUP BY ship_mode
ORDER BY total_sales DESC;
--Q15. Is longer delivery time associated with lower sales or profit?
SELECT
    delivery_days,
    ROUND(AVG(sales)::numeric,2) AS avg_sales,
    ROUND(AVG(profit)::numeric,2) AS avg_profit
FROM superstore
GROUP BY delivery_days
ORDER BY delivery_days;
--Q16. Which shipping mode has the shortest average delivery time?
SELECT
    ship_mode,
    ROUND(AVG(delivery_days)::numeric,2) AS avg_delivery_days
FROM superstore
GROUP BY ship_mode
ORDER BY avg_delivery_days;
--Product Performance

--Q17. What are the top 10 best-selling products in each category?
WITH ProductSales AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY category, product_name
),
RankedProducts AS (
    SELECT
        category,
        product_name,
        ROUND(total_sales::numeric, 2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS rank
    FROM ProductSales
)

SELECT
    category,
    rank,
    product_name,
    total_sales
FROM RankedProducts
WHERE rank <= 10
ORDER BY category, rank;

--Q18. Which product category generates the highest revenue?
SELECT
    category,
    ROUND(SUM(sales)::numeric,2) AS total_revenue
FROM superstore
GROUP BY category
ORDER BY total_revenue DESC;
--Q19. Which sub-category generates the highest profit?
SELECT
    sub_category,
    ROUND(SUM(profit)::numeric,2) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit DESC;
--Q20. Which products are generating losses despite high sales?
SELECT
    product_name,
    ROUND(SUM(sales)::numeric,2) AS total_sales,
    ROUND(SUM(profit)::numeric,2) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_sales DESC;
--Discount & Profitability

--Q21. Does giving higher discounts reduce profit?
SELECT
    discount_percentage,
    ROUND(AVG(profit)::numeric,2) AS avg_profit
FROM superstore
GROUP BY discount_percentage
ORDER BY discount_percentage;

--Q22. Which category receives the highest average discount?
--Which customers contribute the most revenue? (Top 10 Customers)
SELECT
    customer_name,
    ROUND(SUM(sales)::numeric,2) AS total_sales
FROM superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;
--Q23. Which products have the highest profit margin?
SELECT
    product_name,
    ROUND(
        (SUM(profit) / SUM(sales) * 100)::numeric,
        2
    ) AS profit_margin_percent
FROM superstore
GROUP BY product_name
HAVING SUM(sales) > 0
ORDER BY profit_margin_percent DESC
--Q24.Which states have high sales but low profit?SELECT
select state,
    ROUND(SUM(sales)::numeric,2) AS total_sales,
    ROUND(SUM(profit)::numeric,2) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_sales DESC;
