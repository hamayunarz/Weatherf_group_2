-- Functions for Aggregation Data in SQL\


SELECT * FROM flights 



/* Q1.1 What is the total number of rows in the flights table?
 * 		Please provide the query and answer below.
 */

SELECT count(*) FROM flights

/* Q1.2 What is the total number of unique airlines in the flights table?
 * 		Please provide the query and answer below.
 */

SELECT count(DISTINCT airline) FROM flights


/* Q3. How many airports does Germany have?
 * 
 *     Please provide the query and answer below.
 */
SELECT count(DISTINCT name) FROM airports WHERE country = 'Germany'



/* Q4. How many flights had a departure delay smaller or equal to 0?
 *     Please provide the query and answer below.
 */
SELECT count(*) FROM flights WHERE dep_delay <= 0



/* Q5. What's the first day and what's the last day of flight_dates in the flights table?
 *     Please provide the query and answer below.
 */


select min(flight_date) AS First_Day, max(flight_date) AS Last_Day FROM flights 


/* Q6. What was the average departure delay of all flights on January 1, 2023.
 *     Please provide the query and answer below.
 */


SELECT avg(dep_delay) AS Avg_Delay FROM flights WHERE flight_date = '2024-1-1'



/* Q7.1 How many flights have a missing value (NULL value) as their departure time?
 *      Please provide the query and answer below.
 */
SELECT count(*) FROM flights WHERE dep_time = '';



/* Q7.2 Out of all flights how many flights were cancelled? 
 *      Is this number equal to the number of flights that have a NULL value as their departure time above?
 *      Please provide the query and answer below.
 */

SELECT count(*) FROM flights WHERE cancelled = 1



/* Q7.3 The number of canceled_flights (Q7.2) is higher than the no_dep_time (Q7.1), 
 * 		which means there are flight records with departure time (flight started) but the flights were stil cancelled.
 * 		Show those canceled flight with departure time.
 */

SELECT count(*) FROM flights WHERE cancelled = 1 AND dep_time IS NOT NULL 




/* Q8. What's the total number of flights on January 1, 2023 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */


SELECT count(*) FROM flights WHERE flight_date = '2024-1-1' AND (cancelled = 1 or dep_time IS NULL)




/* Q9. What's the number of airlines that had flights on January 1, 2023 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */

SELECT count(DISTINCT airline) AS Num_Airlines FROM flights WHERE flight_date = '2024-1-1' AND (cancelled = 1 or dep_time IS NULL)




/* Q10. Which airport has the lowest altitude?
 *      Please provide the query and answer below.
 */

SELECT * FROM airports ORDER BY alt LIMIT 1