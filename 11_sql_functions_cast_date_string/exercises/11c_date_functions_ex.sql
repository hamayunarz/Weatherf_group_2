/* Exercises
 * Now it's time to put what you've learned into practice.
 * The following exercises need to be solved using the flights and airports table from the PostgreSQL database 
 * you've already worked with.
 * Challenge your understanding and try to come up with the correct solution.
 *
 *
 * 1. What's the current date?
 *    Please provide the query below.
 */
SELECT current_date
 

/* 2.1 Return the current timestamp and truncate it to the current month.
 *     Please provide the query below.
 */
SELECT EXTRACT(MONTH FROM current_timestamp )

/* 2.2 Return a sorted list of all unique flight dates available in the flights table.
 *     Please provide the query below.
 */   
SELECT * FROM flights
SELECT DISTINCT flight_date FROM flights
/* 2.3 Return a sorted list of all unique flight dates available in the flights table and add 30 days and 12 hours to each date.
 *     Please provide the query below.
 */   
SELECT DISTINCT flight_date + INTERVAL '30 days' + INTERVAL '12 hours' AS hours FROM flights ORDER BY hours 

/* 3.1 Return the hour of the current timestamp.
 *     Please provide the query below.
 */ 
SELECT EXTRACT(hours FROM current_timestamp )

/* 3.2 Sum up all unique days of the flight dates available in the flights table.
 *     Please provide the query below.
 */
SELECT COUNT(DISTINCT flight_date) FROM flights;

/* 3.3 Split all unique flight dates into three separate columns: year, month, day. 
 *     Use these columns in an outer query and recreate an ordered list of all flight_dates.
 */
SELECT EXTRACT(year FROM flight_date) AS YEAR,EXTRACT(Month FROM flight_date) AS MONTH, EXTRACT(day FROM flight_date) AS DAY FROM flights
