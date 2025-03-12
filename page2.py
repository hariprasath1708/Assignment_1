import streamlit as st
import pandas as pd
import pymysql

# Database connection
mydb = pymysql.connect(
    host="localhost",
    user="root",
    password="root",
    database="retailorders"
)
st.title('Retail Order Analysis')
st.title('Mini Project ')
# List of predefined queries (questions)
queries = {
    # Add new queries here as needed
    "1.Find the top 5 states with the highest total revenue": """
        SELECT r1.state, SUM(r2.sale_price) AS total_revenue 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.state 
ORDER BY total_revenue DESC 
LIMIT 5;

    """,
    "2.Find the average profit for each product sub-category": """
       SELECT r2.sub_category, AVG(r2.profit) AS avg_profit 
FROM retailorders r2 
GROUP BY r2.sub_category;

    """,
    "3.Calculate the total quantity sold per region": """
       SELECT r1.region, SUM(r2.quantity) AS total_quantity 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.region 
ORDER BY total_quantity DESC 
LIMIT 1;


    """,
    "4.Find the city with the highest average discount percentage": """
   SELECT r1.city, AVG(r2.discount) AS avg_discount 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.city 
ORDER BY avg_discount DESC 
LIMIT 1;
""",
    "5.Identify the top 3 regions with the highest total profit": """
        SELECT r1.region, SUM(r2.profit) AS total_profit 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.region 
ORDER BY total_profit DESC 
LIMIT 3;

""",
    "6.Find the total revenue and total profit for each year": """
        SELECT EXTRACT(YEAR FROM CAST(r1.order_date AS DATE)) AS year, 
       SUM(r2.sale_price) AS total_revenue, 
       SUM(r2.profit) AS total_profit 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY year 
ORDER BY year;

    """,
    "7.Find the state with the most number of orders placed": """
        SELECT r1.state, COUNT(r1.order_id) AS total_orders 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.state 
ORDER BY total_orders DESC 
LIMIT 1;
    """,
    "8.Find the average list price and cost price for each product": """
        SELECT r2.product_id, 
       AVG(r2.list_price) AS avg_list_price, 
       AVG(r2.cost_price) AS avg_cost_price 
FROM retailorders r2 
GROUP BY r2.product_id;
    """,
    "9.Calculate the total discount given for each region": """
        SELECT r1.region, SUM(r2.discount) AS total_discount 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r1.region 
ORDER BY r1.region;
    """,
    "10.Find the product with the highest total quantity sold": """
      SELECT r2.product_id, SUM(r2.quantity) AS total_quantity 
FROM retailorders r1 
JOIN retailorders r2 ON r1.order_id = r2.order_id 
GROUP BY r2.product_id 
ORDER BY total_quantity DESC 
LIMIT 1;
    """,

    "21.Total Sales and Average Price by Category": """
        
SELECT product_id,category,sale_price,
    SUM(sale_price) OVER (PARTITION BY category) AS total_sales_by_category,
    AVG(sale_price) OVER (PARTITION BY category) AS avg_price_by_category
FROM Products;   """,
}



# Streamlit UI: Allow the user to choose a query
selected_query = st.selectbox("Choose your query", list(queries.keys()))

# Button to trigger query execution
if st.button("Run Query"):
    try:
        # Execute the SQL query based on user selection
        query = queries[selected_query]
        with mydb.cursor() as cursor:
            cursor.execute(query)
            result = cursor.fetchall()

            # Convert the result to a Pandas DataFrame
            columns = [desc[0] for desc in cursor.description]  # Get column names
            df = pd.DataFrame(result, columns=columns)

            # Display the results in Streamlit
            st.write(f"Results for: {selected_query}")
            st.dataframe(df)

    except Exception as e:
        st.error(f"An error occurred: {e}")


st.link_button("Page 1 ", "http://localhost:8504")