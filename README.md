# CAMP - Booking Management System
A company that operates in the tourism industry has a significant number
camps in our country. The company is mainly aimed at groups of tourists
but also to individual tourists who wish to camp in an area
of our country during their holidays.

# Goal
The company kept all the bookings in an excel file along with the details of the customers and its camps. We created a normalized database 
in the 3rd norm, so that the information is immediately available from the company's systems and reducing the redundant information.
Additionally, we created a data warehouse so that the company can analyze its data for better decision making.

# Normalization and Logic Schema Generation
A relational database with different camping sites has been created. First, the data from the campData.txt file was loaded into the initial campData table. The normalization procedure was then followed to create a logical form in the third normal form. Finally, to manage the data, appropriate SQL commands were used which channel the data to the database tables.

# Indexes and Queries examples
Appropriate indexes are created to speed up query execution. Specifically, an index is created based on the customer and the year of the reservation, while for the total value of the reservations (total revenue) per camp, an index is created based on the camp.

# Data Warehouse and Statistics
We create a data warehouse to analyze the data and generate statistical reports on the progress of bookings and the number of tenants. Requirements focus on booking analysis per customer, camp, seat category, as well as any combination thereof.
