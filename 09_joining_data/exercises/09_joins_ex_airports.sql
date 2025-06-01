/* # JOINS - Exercises */

/* JOINS with Tables: 'flights' and 'airports'  */

/* Q1. What was the longest flight? (not using JOIN yet) 
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */
SELECT 
    ao.name AS origin_airport,
    ad.name AS destination_airport,
    COUNT(*) AS total_flights
FROM 
    flights f
JOIN 
    airports ao ON f.origin = ao.faa
JOIN 
    airports ad ON f.destination = ad.faa
GROUP BY 
    ao.name, ad.name
ORDER BY 
    total_flights DESC
LIMIT 5;
SELECT * FROM flights 

SELECT tail_number, max(air_time) AS Max_Airtime FROM Flights WHERE arr_time IS NOT NULL GROUP BY tail_number ORDER BY Max_airtime Desc

SELECT * FROM flights WHERE air_time IS NOT NULL ORDER BY air_time DESC

/* Q2. From which airport the longest flight? (now with JOIN)
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */
ALTER TABLE flights ADD Foreign KEY (origin) REFERENCES airports(faa)

SELECT * FROM airports WHERE faa = 'SFO'
SELECT * FROM flights

SELECT a.faa, f.air_time AS longest_flight FROM airports a JOIN flights f ON a.faa = f.origin WHERE f.air_time IS NOT NULL ORDER BY longest_flight DESC


/* Q3. The table 'flights' is about domestic flights in US. 
 * 		Let's double-check! 
 * 		Find unique country names for all departures.
 */
SELECT * FROM airports
SELECT DISTINCT a.country FROM flights f left JOIN airports a ON f.origin = a.faa

/* Q4. How many departures per 'country' happened on the first day of our data? (Bonus: on the first month)
 * 
 * 		Hints: 
 * 			- some listed flights were cancelled, let's filter them out
 * 			- 'timestamp' and 'date' types can be compared to (filtered on) strings representing a date, for example to '2020-12-31'
 * 			- to find the first date you can check the MIN(flight_date)
 */ 
SELECT min(flight_date) FROM flights 
SELECT DISTINCT a.country, count(f.dep_time) AS Total_Dep FROM flights f left JOIN airports a ON f.origin = a.faa WHERE f.flight_date = '2024-01-01' AND f.cancelled = 0 GROUP BY a.country
SELECT DISTINCT a.country, count(f.dep_time) AS Total_Dep FROM flights f left JOIN airports a ON f.origin = a.faa WHERE (f.flight_date BETWEEN '2024-01-01' AND '2024-01-31') AND f.cancelled = 0 GROUP BY a.country



/* Q5. Which airport and in which city had the most departures during the first month?
 * 
 * 		Hints: 
 			- filter out cancelled flights
			- filter for flight_date BETWEEN 'start-date' AND 'end-date'
			- use LIMIT to focus on the highest departures, but also check whether only one airport has the most
 */

SELECT DISTINCT a.name AS Airport_name, a.city , count(*) AS Total_Dep FROM flights f JOIN airports a ON f.origin = a.faa 
WHERE (f.flight_date between '2024-01-01' AND '2024-01-31') AND cancelled = 0 GROUP BY a.name,a.city ORDER BY total_dep desc


/* Q6. To which city/cities does the airport with the second most arrivals over all time belong?
 * 
 * 		Hint: 
 			- similar to the LIMIT clause limiting a number of rows the clause OFFSET skips a number of rows
 */
SELECT DISTINCT a.name AS Airport_name, a.city , count(*) AS Total_Dep FROM flights f JOIN airports a ON f.dest  = a.faa 
WHERE cancelled = 0 GROUP BY a.name,a.city ORDER BY total_dep DESC LIMIT 1 OFFSET 1



/* Q7. Filter the data to one date and count all rows for that day so that your result set has two columns: flight_date, total_flights.  
 * 		Repeat this step, but this time only include data from another date.
 * 		Combine the two result sets using UNION.
 */

--> UNION combines the distinct results of two or more SELECT statements
SELECT * FROM flights


SELECT flight_date, COUNT(*) AS total_flights FROM flights WHERE cancelled = 0 AND flight_date = '2024-01-01' GROUP BY flight_date

UNION

SELECT flight_date, COUNT(*) AS total_flights FROM flights WHERE flight_date = '2024-01-02' GROUP BY flight_date;


/* Q8. The last query can be optimized, right?
 * 		Rewrite the query above so that you get the same output, but this time you are not allowed to use UNION.
 * 
 * 		Hint: we can use a filter to get only the data for those 2 days. 
 */

SELECT flight_date, COUNT(*) AS total_flights FROM flights WHERE flight_date = '2024-01-02' OR flight_date = '2024-01-01'  GROUP BY flight_date


/* Q9. Show flights with a departure delay of more than 30 minutes over all time?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which date and in which city did the plane depart?   
 * 	    Answer all questions with a single query.
 */

SELECT * FROM flights
SELECT * FROM airports 

SELECT f.dep_delay, f.tail_number, f.flight_date, a.city FROM flights f JOIN airports a ON f.origin = a.faa WHERE f.dep_delay > 30 

/* Q10. Per airport, over all time, show
 *		- the city and the airport name
 * 		- how many flights had a departure delay of more than 30 minutes?
 *      - what was the average arrival delay for these flights?
 * 		- how many unique airplanes were involved?
 */

SELECT a.city, a.name, count(Distinct f.tail_number) AS Airport_count, count(f.dep_delay) AS Departure_delay, round(avg(arr_delay),2) AS Avg_Arrival_Delay 
FROM flights f JOIN  airports a ON f.origin = a.faa WHERE f.dep_delay > 30 AND f.cancelled = 0 GROUP BY a.city, a.name ORDER BY airport_count DESC 

/* Q11. Find city names with :
 * 		- the most daily total departures
 * 		- the most daily unique planes departed
 * 		- the most daily unique airlines
 *
 * Use VIEWs to create the final join query:
 * 		1. VIEW calculating counts (departures, tails, airlines) per flight date and city. (Hint: filter out cancelled flights)
 * 		2. VIEW (querying from the 1st view) finding the max daily values over all for counts of departures, tails and airlines
 * 		3. In the final query join the 1st view to the 2nd on the max values 
 *    		Hint #1: the ON takes OR keywords
 *    		Hint #2: to tackle the case that the same airport has highscores on multiple days add a group by city and aggregate the metrics.
 * 
 * OPTIONAL: to count the number of the airports in a city STRING_AGG(DISTINCT origin, ', ')
 */


SELECT
	v.city,
	MAX(Most_daily) AS Max_Delay,
	MAX(Daily_Unique_Plane) AS Max_Daily,
	MAX(Unique_Airline) AS Max_Airlines
FROM
	(
	SELECT
		a.city,
		count(f.dep_delay) AS Most_daily,
		count(DISTINCT f.tail_number) AS Daily_Unique_Plane,
		count(DISTINCT f.airline) AS Unique_Airline
	FROM
		flights f
	JOIN airports a ON
		f.origin = a.faa
	WHERE
		f.cancelled = 0
	GROUP BY
		a.city) v
GROUP BY
	v.city

	
	
	
	
CREATE OR REPLACE VIEW Max_Final AS
SELECT
    v.city,
    MAX(v.Most_daily) AS Max_Delay,
    MAX(v.Daily_Unique_Plane) AS Max_Daily,
    MAX(v.Unique_Airline) AS Max_Airlines
FROM (
    SELECT
        a.city,
        COUNT(f.dep_delay) AS Most_daily,
        COUNT(DISTINCT f.tail_number) AS Daily_Unique_Plane,
        COUNT(DISTINCT f.airline) AS Unique_Airline
    FROM flights f
    JOIN airports a ON f.origin = a.faa
    WHERE f.cancelled = 0
    GROUP BY a.city
) v
GROUP BY v.city;

SELECT * FROM Max_Final;

CREATE VIEW Cal AS SELECT a.city, count(f.dep_delay) AS Most_daily,count(DISTINCT f.tail_number) AS Daily_Unique_Plane, count(DISTINCT f.airline) AS Unique_Airline FROM flights f
JOIN airports a ON f.origin = a.faa WHERE f.cancelled = 0 GROUP BY a.city




SELECT * FROM cal
CREATE VIEW Final_11 AS SELECT v.city, MAX(Most_daily) AS Max_Delay, MAX(Daily_Unique_Plane) AS Max_Daily, MAX(Unique_Airline) AS Max_Airlines
FROM (SELECT a.city, count(f.dep_delay) AS Most_daily,count(DISTINCT f.tail_number) AS Daily_Unique_Plane, count(DISTINCT f.airline) AS Unique_Airline FROM flights f
JOIN airports a ON f.origin = a.faa WHERE f.cancelled = 0 GROUP BY a.city) v GROUP BY v.city

SELECT * FROM Final_11

SELECT * FROM FLIGHTS



For the route ('JFK', 'LAX') january, 
--compare the number of daily flights with the maximum of daily flights per month.
-- daily flights totals 
-- compare to the max flight for the month
 -- AS a CTE


WITH counts AS (
    SELECT 
        origin, 
        dest, 
        flight_date, 
        COUNT(*) AS flights
    FROM flights
    WHERE flight_date BETWEEN '2024-1-1' AND '2024-1-31' AND cancelled = 0 AND (origin = 'JFK' AND dest = 'LAX' )
    GROUP BY origin, dest, flight_date
)
SELECT 
    flight_date,
    flights AS daily_flight,
    (SELECT MAX(flights) FROM counts) AS max_flights
FROM counts
--WHERE origin = 'JFK' AND dest = 'LAX' 
ORDER BY flight_date;

SELECT 


SELECT max(flighhst) FROM flights 









