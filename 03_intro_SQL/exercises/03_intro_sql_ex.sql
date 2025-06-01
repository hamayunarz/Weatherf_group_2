/* Q1. Select the first 20 rows of all columns in the 'flights' table.
 *      Please provide the query below.
 */
SELECT * FROM flights LIMIT 20


/* Q2. Select the first 20 rows the 'flights' table with columns that have
 * 	   - the date of the flight,
 * 	   - the airport code of the origin airport
 * 	   - the airport code of the destination airport
 * 	   - information whether the flight was cancelled or not
 *     Please provide the query below.
 */

SELECT flight_date, origin, dest, cancelled FROM flights LIMIT 20


/* Q3. What's the name of the airport that is shown in the first row when sorting by airport code descending?
 * 	   Hint: the whole row is too much information, show only the necessary fields.
 *     Please provide the query and answer below.
 * 
 * 
 */

SELECT * FROM airports  ORDER BY faa DESC

-- ZZV


/* Q4. Return a list of all unique countries with an airport in this table. 
 * 	   What does that tell you about the airports table?
 *     Please provide the query below.
 */

SELECT DISTINCT country FROM airports


/* Q5. Select the country, city and name of all airports. 
 * 	    Sort city in ascending and name in descending order.
 * 		What's the name of the airport that is listed last?
 *      Hint: somethimes you need to put things upside down to see what is at the bottom.
 *      Please provide the query below.
 */
SELECT country, city, name FROM airports ORDER BY city ASC, name DESC  

SELECT country, city, name FROM airports ORDER BY city DESC , name asc limit 3

-- Austrailia

/* Q6. Which airport has the lowest altitude?
 * 
 *      Please provide the query and answer below.
 */
SELECT min(alt ) FROM airports

SELECT * FROM airports ORDER BY  alt ASC  

/* Q7. Which airport would have the lowest altitude if we transformed all positive altitudes into negative altitudes and vice versa?
 *     Hint: How can you mathematically make a 10 to -10? 
 * 	   Please provide the query and answer below.
 */
SELECT faa, name, alt * -1 AS neg_alt FROM airports ORDER BY neg_alt ASC  

SELECT faa, name, alt FROM airports ORDER BY alt DESC   


 /* Q8. Give each column selected in the query below a more descriptive name using aliasing.
 * 		If you're not sure what the column means, check out this documentation: https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf
 */
SELECT faa AS airport_code,
	   lat AS lattiutde , 
	   lon AS llll,
	   alt AS old_distination,
	   tz AS tttt,
	   dst AS distination
FROM airports;

-- BONUS: probably obsolete

 /* Q9. Create a column that turns dep_delay into a categorical variable with one of 5 categories.
 * Depending on the delay a flight will be either:
 * '>15 min Early', '<=15 min Early', 'On time', '<=15 min Delayed' or '>15 min Delayed'.
 */