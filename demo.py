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
    "1.Find top 10 highest revenue generating products": """
        SELECT product_id, category, SUM(quantity * sale_price) AS total_revenue
        FROM retailorders
        GROUP BY product_id, category
        ORDER BY total_revenue DESC
        LIMIT 10;
    """,
   "2.Find the top 5 cities with the highest profit margins": """
    SELECT city, SUM((sale_price - cost_price) / sale_price) AS total_profit_margin
    FROM retailorders
    GROUP BY city
    ORDER BY total_profit_margin DESC
    LIMIT 5;
""",
    "3.Calculate the total discount given for each category": """
        SELECT category, SUM(discount) AS total_discount
        FROM retailorders
        GROUP BY category;
    """,
    "4.Find the average sale price per product category": """
        SELECT category, AVG(sale_price) AS avg_sale_price
        FROM retailorders
        GROUP BY category;
    """,
    "5.Find the region with the highest average sale price": """
        SELECT region, AVG(sale_price) AS avg_sale_price
        FROM retailorders
        GROUP BY region
        ORDER BY avg_sale_price DESC
        LIMIT 1;
    """,
    "6.Find the total profit per category": """
        SELECT category, SUM(profit) AS total_profit
        FROM retailorders
        GROUP BY category;
    """,
    "7.Identify the top 3 segments with the highest quantity of orders": """
        SELECT segment, SUM(quantity) AS total_orders
        FROM retailorders
        GROUP BY segment
        ORDER BY total_orders DESC
        LIMIT 3;
    """,
  "8.Determine the average discount percentage given per region": """
     SELECT region, AVG(discount) AS avg_discount_percentage
     FROM retailorders
     GROUP BY region;
 """,


    "9.Find the product category with the highest total profit":"""
        SELECT category, SUM(profit) AS total_profit
        FROM retailorders
        GROUP BY category
        ORDER BY total_profit DESC
        LIMIT 1;
    """,
  "10.Calculate the total revenue generated per year": """
    SELECT YEAR(order_date) AS year, SUM(quantity * sale_price) AS total_revenue
    FROM retailorders
    GROUP BY year
    ORDER BY year;
"""

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




st.link_button("Page 2 ", " http://localhost:8503/")