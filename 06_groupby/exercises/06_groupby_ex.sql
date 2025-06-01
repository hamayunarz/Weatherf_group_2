-- GROUP BY Exercises
SELECT * FROM flights  
/* Q1.1 Which country has the highest number of airports?
 *       Please provide the query and answer below.
 */
SELECT country, count(DISTINCT faa) AS Max_airport FROM airports GROUP BY country ORDER BY Max_airport DESC LIMIT 1

 /* Q1.2 Change the query of Q1, so that we also see the timezone along with the country.
 *       Please provide the query and answer below.
 */
 
SELECT country, tz, count(DISTINCT faa) AS Max_airport FROM airports GROUP BY country, tz ORDER BY Max_airport DESC 

/* Q2. Which city has the highest number of airports?
         Hint: there are many cities with the same name.
 *       Please provide the query and answer below.
 */
SELECT city, country, count(*) AS Max_airport FROM airports WHERE city IS NOT NULL GROUP BY city, country ORDER BY Max_airport DESC


 /* Q3. What's the average altitude of airports per country?
 *       Please provide the query and answer below.offset
 */
 SELECT country, avg(alt) AS Avg_Alt FROM airports GROUP BY country

/* Q4. Only show airports of the US. Which city of the US has the highest number of airports?
 * 		 (bonus: Which city of the US has the airport with the highest altitude?) 
 *       Please provide the query and answer below.
 */

SELECT city, count(DISTINCT faa) AS Max_Airport FROM airports WHERE country = 'United States' GROUP BY city ORDER BY Max_Airport Desc 
 
SELECT city, Max(alt) AS Highest_alt FROM airports WHERE country = 'United States' GROUP BY city ORDER BY Highest_alt Desc 

SELECT count(*) FROM flights WHERE actual_elapsed_time IS NULL 



/* Q5. Which plane has flown the most flights? Provide the plane number, the airline it belongs to, and how often was it in the air
 *      Hint: cancelled is not "in the air"
 *      Please provide the query and answer below.
 */

SELECT airline, tail_number AS Plan_Number,  count(*) AS Flight_Air FROM Flights WHERE cancelled = 0 AND air_time IS NOT NULL GROUP BY airline, tail_number ORDER BY Flight_Air DESC 



/* Q6. How many planes have flown just a single flight?
 * 		Please provide the query and answer below.
 */

SELECT tail_number AS Plan_Number, count(flight_number) AS Flight_Air FROM Flights WHERE cancelled = 0 GROUP BY tail_number HAVING COUNT(flight_number) = 1 



SELECT airline, COUNT(*) AS Total_Flights, ROUND(AVG(air_time), 2) AS Avg_Air_time, ROUND(AVG(distance)::Numeric, 2) AS Avg_Distance, MAX(arr_delay) AS Max_Delay
FROM flights WHERE cancelled = 0 GROUP BY airline ORDER BY total_flights DESC;



/* Q7. Let's understand our airlines a bit better...
* Please summarize in one table the following performance metrics per airline:
* - the nr of total flights
* - the average time in the air per flight
* - the average distance flown per flight
* - the maximum delay on arr

