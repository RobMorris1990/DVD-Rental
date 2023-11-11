-- Taking a look at the address table.
SELECT * FROM address;


-- Show the phone numbers for all addresses in the Punjab district.
SELECT phone FROM address
WHERE district = 'Punjab';


-- Filter the address table to show all address id’s between 100 and 200.
SELECT * FROM address
WHERE address_id BETWEEN 100 AND 200;


-- List all the districts in the address table, without including duplicate values.
SELECT DISTINCT(district)
FROM address
ORDER BY district;


-- How many payments were made over the value of 5.00?
SELECT COUNT(amount)
FROM payment
WHERE amount > 5.00;


-- How many payments were made over the value of 5.00 to staff id number 2?
SELECT COUNT(amount)
FROM payment
WHERE amount > 5.00
AND staff_id = 2;


-- What were the last 30 payments made, where a monetary transaction took place by staff member 1?
SELECT * FROM payment
WHERE staff_id = 1
AND amount != 0
ORDER by payment_date DESC
LIMIT 30;


-- List all payments made that had either the value 4.99 or 5.98. Order these by staff_id ASC, then by amount DESC.
SELECT * FROM payment
WHERE amount IN (4.99,5.98)
ORDER BY staff_id ASC, amount DESC;


-- Filter the actor table, showing records for first names that begin with ‘Al’.
SELECT * FROM actor
WHERE first_name LIKE 'Al%';


-- What is the largest payment made?
SELECT MAX(amount) FROM payment;


-- What is the average payment made?
SELECT ROUND(AVG(amount),2) FROM payment;


-- Show all rentals of inventory_id 1711 that had a return date in 2005.
SELECT * FROM RENTAL
WHERE inventory_id = 1711
AND return_date BETWEEN '2005-01-01' AND '2006-01-01';


-- What were the top 5 days in 2006 in terms of sum total of transactions?
SELECT DATE(payment_date), SUM(amount) FROM payment
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC
LIMIT 5;


-- How many transactions were made by each staff member?
SELECT staff_id, COUNT(*) FROM payment
WHERE amount > 0
GROUP BY staff_id;


-- Joining the payment and customer tables
SELECT payment_id, p.customer_id, rental_id, amount, first_name, last_name, email
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id;


-- Multiple joins to get the names of films each customer has rented
SELECT payment_id, p.customer_id, p.rental_id, amount, first_name, last_name, email, f.film_id, title
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i
ON r.rental_id = i.inventory_id
INNER JOIN film f
ON i.film_id = f.film_id
ORDER BY customer_id, rental_id;


-- Find the percentage of the replacement cost that each rental is worth
SELECT film_id, title, rental_rate, replacement_cost, ROUND((rental_rate/replacement_cost)*100,1) AS percent_of_cost 
FROM film
ORDER BY film_id;


-- Running total of payments by date for March 2007
SELECT payment_id, customer_id, staff_id, rental_id, amount, DATE(payment_date) AS pay_date,
SUM(amount) OVER (PARTITION BY DATE(payment_date) ORDER BY payment_date) AS running_total
FROM payment
WHERE payment_date BETWEEN '2007-03-01' AND '2007-03-31'
ORDER BY payment_date;


-- Grouping days in March 2007 to find sum of payments for each day
SELECT CAST(payment_date as DATE) AS payment_day, SUM(amount)
FROM payment
WHERE payment_date BETWEEN '2007-03-01' AND '2007-03-31'
GROUP BY payment_day
ORDER BY payment_day;


-- Grouping days in March 2007 to find sum of payments for each day and running total across the month
SELECT CAST(payment_date as DATE) AS payment_day, 
SUM(amount),
SUM(SUM(amount)) OVER(ORDER BY DATE(payment_date))
FROM payment
WHERE payment_date BETWEEN '2007-03-01' AND '2007-03-31'
GROUP BY payment_day
ORDER BY payment_day;


-- Creating a View
CREATE VIEW march_2007_payments AS
SELECT payment_id, customer_id, staff_id, rental_id, amount, DATE(payment_date) AS pay_date,
SUM(amount) OVER (PARTITION BY DATE(payment_date) ORDER BY payment_date) AS running_total
FROM payment
WHERE payment_date BETWEEN '2007-03-01' AND '2007-03-31'
ORDER BY payment_date;


-- Looking at the view
SELECT * FROM march_2007_payments;

