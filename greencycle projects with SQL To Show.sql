--LIST OF ALL THE CUSTOMERS FIRST NAME,last name and emails

SELECT FIRST_NAME,
	LAST_NAME,
	EMAIL
FROM CUSTOMER;

--order the customer list by last name from'Z' to 'A'
--in case of the same last name the order should be by first name 

SELECT FIRST_NAME,
	LAST_NAME,
	EMAIL
FROM CUSTOMER
 Order by last_name DESC, first_name DESC;
 
--Different prices that have been paid from high to low

SELECT DISTINCT amount from payment

order by amount DESC;

---Last 10 rental date

SELECT *from rental
order by rental_date DESC
LIMIT 10;

--How many customer we have

SELECT count(*)
from customer;

--How many payement were made by customer with customer_id =100

SELECT COUNT(amount) from payment
where customer_id = 100;

--What is the last name of our customer with first name  'ERICA'

SELECT first_name,last_name from customer
where first_name = 'ERICA';

--How many rentals have not been returned yet

  SELECT count(*) from rental
  where return_date is null;
  
--List of all the payment_ID with an amount less or equa to $2,include the payment_id

 SELECT payment_id,amount from payment
 where amount <= 2;
 
 --List of all payment of the customer 322,346,354 where the amount is less than 2 or greater than 10
 --Should order by customer first name ASC and then as a second condition order by amount descending order
 
 SELECT * from payment
 where (customer_id= 322 or customer_id=346 or customer_id=354) and (amount <2 or amount >10)
 order by customer_id ASC, amount DESC;
 
 --How many payments have been made on January 26th and 27th 2020 with amount between 1.99 and 3.99
 
 SELECT count(*) from payment
 where payment_date between '2020-01-26' and '2020-01-27 23:59'
 and amount between 1.99 and 3.99;
 
 --retrieve payments for customer_id: 12,25,67,93,124,234, where amount 4.99,7.99 and 9.99 in January 2020
 
 select * from payment
 where customer_id IN(12,25,67,93,124,234)
 and amount in (4.99,7.99,999)
 and payment_date between '2020-1-1' and '2020-1-31 23:59';
 
 --How many movies are there that contain the 'Documentary' in there description
 
 Select count(*) from film
 where description like '%Documentary%';
 
/*How many customers are there with a first name that is 3 letters long
 and either and 'X' or 'Y' in the last letter of the last name */
 
  Select count (*)  from customer
  where first_name like '___'
  and (last_name like '%X'
  OR last_name like '%Y');
  
 --Replacement cost analysis
 
 Select
 MIN(replacement_cost),
 MAX(replacement_cost),
 Round(AVG(replacement_cost),2) AS Average_replacment_cost,
 SUM(replacement_cost)
 From film;
 
/*Which of the two employees (staff_id)is responsible for more payments.
 Which pf the two is responsible for higher oveall payment amount*/
 
 Select staff_id, SUM(amount), count (amount) from payment
 group by staff_id;

-- How do these amounts change if we don't consider amounts equal 0.
 
 SELECT staff_id,SUM(amount), count(amount) from payment
 Where  amount != 0
 group by staff_id;
 
-- Which employee had the higest sales amount in a single day
-- Which employee had had the most sales in a single day( not counting payment with amount=0)

  Select staff_id , Sum(amount),Count(*),
  DATE(payment_date)
  from payment
  WHERE amount != 0
  group by staff_id,DATE(payment_date)
  order by  count(*) DESC;
  
 --In 2020, April28,29 and 30 were days with higest revenue.
/*Find out what is the average payment amount group by customer and day.
Consider only the days/customers with more than 1 payment per customer per day.
Order by the average amount is descending order*/

Select customer_id, Date(payment_date),count(*),
round(AVG(amount),2) AS average_payment
From payment
Where Date(payment_date) IN ('2020-04-28','2020-04-29','2020-04-30') 
Group by customer_id, Date(payment_date)
Order by average_payment DESC;

--Find customers where either the first name or the last name is more than 10 charaters long
--Display all the name on lower case

Select LOWER(first_name), LOWER(last_name),
LENGTH(first_name),
LENGTH (last_name)
from customer
WHERE 
(LENGTH(first_name) >10 
LENGTH(last_name) >10);

--Extract the last 5 character of the email address

Select
RIGHT(email,5)
from customer;

--The email address always end with'.org'--How can you extract just the dot '.'

Select
LEFT(RIGHT(email,4),1)
from customer;

--Create a list of initials for all the customers

Select
 Left(first_name,1) || '.' || left(last_name,1),
 first_name,last_name
 from customer;
 
--Create an anonymized version of the email addresses, it should be first charactre followed by ***

Select
Left(email,1)|| '***'|| RIGHT(email,19) AS anonymized_email
from customer;

/*You need to extract the first name from the email address and concatenate it with last name
it should be in the form : Last name, First name*/

Select 

last_name || ','|| LEFT(email,Position('.' IN email)-1)
from customer

--Create anonymized from email addresses in the following way:M***.s***@sakilacustomer.org

Select
email,
LEFT(email,1)||'***'||
SUBSTRING (email from Position('.'IN email)for 2)
||'***'||SUBSTRING (email from Position('@'IN email))
from customer
--Create anonymized from email addresses in the following way:***M.s***@sakilacustomer.org

Select '***'
|| SUBSTRING(email from Position('.' IN email)-1 for 3)
||'***'||SUBSTRING (email from Position('@' IN email))
FROM customer

--What's the month with higest total payment amount.

Select 
EXTRACT(month from payment_date) AS month,
SUM(amount) AS total_payment_amount
from payment
GROUP BY EXTRACT(month from payment_date)
ORDER BY SUM(amount) DESC

--What's the day of week with the higest total payment.

Select 
EXTRACT(dow from payment_date) AS day_of_week,
SUM(amount) AS total_payment_amount
from payment
GROUP BY EXTRACT(dow from payment_date)
ORDER BY SUM(amount) DESC

--What's the higest amount one customer has spent in a week

Select customer_id,
EXTRACT(week from payment_date) AS week,
SUM(amount) 
from payment
GROUP BY  customer_id,week
ORDER BY SUM(amount) DESC

--Sum payments and group in the following formats: Day,day/month/year , (Day, year) and (day and hour:minutes)

Select 
Sum(amount),
TO_CHAR(payment_date, 'DAY,dd/mm/yyyy')
from payment
group by TO_CHAR(payment_date, 'DAY,dd/mm/yyyy')

--
Select 
Sum(amount),
TO_CHAR(payment_date, 'MON,YYYY')
from payment
group by TO_CHAR(payment_date, 'MON,YYYY')

--
Select 
Sum(amount),
TO_CHAR(payment_date, 'DY,HH:MI')
from payment
group by TO_CHAR(payment_date, 'DY,HH:MI')

--Create a list for the support team of all the rental duration of customer with customer_id 35

Select customer_id,
return_date-rental_date
from rental where customer_id= 35

--Which customer has the longest average rental duration

Select customer_id,
AVG(return_date-rental_date)
from rental
group by customer_id
order by AVG(return_date-rental_date) DESC;

--Incease the rental rate by $1

Select film_id,
rental_rate as old_rate,
rental_rate+1 as new_rate
from film

--Incease the rental rate by 10% ( round the amount)

Select film_id,
rental_rate as old_rate,
ROUND(rental_rate*1.1) as new_rate
from film;

--Create a list of the films including the relation of rental rate/ replacement cost where the rental rate is less than 4% of the replacement cost

Select film_id,
ROUND(rental_rate/replacement_cost*100,2) percentage
from film
WHERE ROUND(rental_rate/replacement_cost*100,2) <4
order by 2 DESC

/* Create a tier list in the following way:
1-Rating is 'PG' or 'PG-13' or length is more then 210 minutes:'Great rating or long(tier1)'
2-Description contains 'Drama'and length is more than 90 minutes:'Long Drama(tier2)'
3-Description contains 'Drama'and length is Not more than 90 minutes:'Short Drama(tier3)'
4-Rental_rate less than $1:'Very cheap(tier4)' */

Select 
title,
CASE
WHEN rating IN('PG' , 'PG-13') OR length >210 THEN 'Great rating or long(tier1)'
WHEN description LIKE'%Drama%' OR length >90 THEN 'long Drama(tier2)'
WHEN description LIKE'%Drama%' OR length <90 THEN 'Short Drama(tier3)'
WHEN rental_rate<1 THEN 'Very Cheap(tier4)'
END as tier_list
FROM film

--Many times the return_date is filled with 'null' we would like to replace with value not returned

Select
rental_date,
COALESCE(CAST (return_date AS varchar),'Not returned')
from rental
order by return_date DESC
