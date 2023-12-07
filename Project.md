## Goal 

This analysis of sales data from an IT-reseller aims at answering the following questions in order to efficiently plan and implement the advertisement campaign for 2021: 

   1. What is the best month for sales? What is the total revenue in the highest selling month?
   2. What is the best day of the month for sales? Is there an increase in sales after payday?
   3. What time should we diplay advertisements to maximize the likelihood of customers buying product? 
   4. What cities sold the most product? What is their total yearly revenue? 
   5. What is the average monthly number of orders and sales in each state? 
   6. What product sold the most and is there a product bundle that sold particularly good?

## Data

The original dataset is downloaded from [Kaggle](https://www.kaggle.com/datasets/beekiran/sales-data-analysis). It contains 11 variables and 185950 records of products ordered in 2019. Certains variables (month, hour, state, city) have been dropped and recreated in SQL to practice string and date functions. 

The SQL code [Data Preparation](1_DataPreparation.sql) creates the initial table and load the data from the .csv file. It then adds the following variables: 
   * Total sales (revenue)
   * State, city, zipcode of purchase address
   * Month, hour of purchase

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL2.png" width = 80% height=80%>
</p>
<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL3.png" width = 30% height=30%>
</p>

The dataset for the analysis is structured as shown hereafter:

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL14.png" width = 90% height=100%>
</p>

## Explorative Data Analysis

Complete SQL code: [Explorative Data Analysis](2_EDA.sql)

#### **Question 1**: What is the best month for sales? What is the total revenue in the highest selling month?

In 2019 a total of 178'437 orders have been made for a total of 34'499'750 US$ in sales. As the chart below shows, December has been the best month both in terms or quantity of orders registered and total sales made, respectively around 24 thousand orders and 4.5M US$ in sales. IT products such as pc, iPhone, headphones, and others, are a favorite gifts made for Christmas. 

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau1.png" width = 90% height=100%>
</p>

#### **Question 2**: What is the best day of the month for sales? Is there an increase in orders after payday?

We don't observe a clear trend in sales and order made with respect to the days of the month, even though the 26th and 27th of the month figure among the days with most orders registered,

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL17.png" width = 20% height=40%>
</p>


#### **Question 3**: What time should we diplay advertisements to maximize the likelihood of customers buying product?

The hours with the most products ordered are 11am, 12pm and 7pm, suggesting therefore that the best time to display product advertisement is slightly before 11am and/or 7pm. 

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau3.png" width = 90% height=100%>
</p>


#### **Question 4**: What cities sold the most product? What is their total yearly revenue? 

The top 3 highest selling cities are: San Francisco (CA), Los Angeles (CA), and New York City (NY). Around 50'000 products have been sent to an address in San Francisco, for a total of slightly over 8M US$ in sales made from these purchases. 

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL18.png" width = 30% height=50%>
</p>

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau4.png" width = 90% height=100%>
</p>

#### **Question 5**: What is the average monthly number of orders and sales in each state?

The graph below shows the evolution of average monthly sales across 2019 for each state. We can observe that for all the states with the exception of Maine, the average sales are approximately constant over the entire year and remain in the range 170-200 US$. 

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL9.png" width = 60% height=80%>
</p>

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau5.png" width = 90% height=100%>
</p>

#### **Question 6**: What product sold the most and is there a product bundle that sold particularly good?

The graph on quantity sold of each product and their price shows that there is as expected an inverse relationship between the quantity sold and unit price. Batteries and charging cables sold a lot. Only few dryers and washing machines have been sold in 2019, due to their longer lifecycle.

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau6.png" width = 90% height=100%>
</p>

The product bundle that sold the most is "iPhone - Lighting charging cable", with 1'005 unit sold. In all the top 5 product bundles sold we find the pair *phone - accessory*. 

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/Tableau7.png" width = 90% height=100%>
</p>

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL10.png" width = 60% height=80%>
</p>

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL11.png" width = 60% height=80%>
</p>

<p align = "center">
  <img src="https://github.com/Stolemi/Sales-Data-Analysis/blob/main/Screenshots/SQL12.png" width = 40% height=60%>
</p>

## Coclusions

This analysis applies different SQL procedures and functions in order to extrapolate useful insights for the planning of future advertisement campaign from data on sales registered by an IT-reseller in 2019. The main conclusions can be summarized as follow: 
   * December is the best selling month, mainly due to the presence of festivities such as Christmas for which IT-product are a favorite. The advertisement campaign should therefore focus more on months with lower selling numbers, such as January, that have margin of improvement. 
   * There is no evidence to support the hypothesis that people purchase more after receiving their monthly salary. The planning of future advertisement campaigns should focus on other aspects, such as the hours in which displaying the ads. The data shows that purchases are frequently done around 11am-12pm and 7pm, which should be targeted with ads to sponsor products difficult to sell (dryers, laptops, etc.).
   * The major US cities registered the most orders as well as the highest sales. These cities are the economic centers of the country and especially California host most tech-companies, making them top customer for IT-products.
   * Phone and phone accessories are the most frequently bought products.



