-- CIUD/CRUD Exercises
 
/* Q1.1 Create a new table called customers in your schema from public.messy_customer_data
 * where the address is not missing (NULL) and order by customer_name.
 */

CREATE TABLE customers AS SELECT * FROM public.messy_customer_data WHERE address IS NOT null

SELECT * FROM customers
 /* Q1.2 How many rows are in your new table?
 */

SELECT count(*) FROM customers

-- 200 Rows

/* Q2. A new customer, "Spicer Fischer" from the Kingdom of the North (KN) with email address spicer.new@fisches.com and no address info
 * has just registered. Add his details into the customers table.
 */

INSERT INTO customers(customer_name, email, country) VALUES('Spicer Fischer','spicer.new@fisches.com ','KN')


/* Q3. The company now wants to track customer signup dates. Add a new column signup_date to store this information.
 */


ALTER TABLE customers ADD COLUMN signup_date date 

/* Q4. Set the signup date for all customers in the customers table to January 1, 2024.
 */

UPDATE customers SET signup_date = 'January 1, 2024'


/* Q5. A customer named "Spicer Fischer" has now provided his address. Update it to "123 White Harbor".
 */

UPDATE customers SET address = '123 White Harbor' WHERE customer_name = 'Spicer Fischer'


/* Q6. Find out how many customers are from Bulgaria (BG) and Grenada (GD).
 */

SELECT count(*) FROM customers WHERE country IN ('BG','GD')



SELECT * FROM customers


/* Q7. Rename the customer_name column to company_name.
 * 
*/

ALTER TABLE customers rename customer_name to company_name

/* Q8.The customer named "Spicer Fischer" has been flagged as spam. Remove them from the customers table.
*/

DELETE FROM customers WHERE company_name ='Spicer Fischer'


/* Q9.Change the table name from customers to customer_clean.
*/

ALTER TABLE customers rename to customer_clean

SELECT * FROM customer_clean


