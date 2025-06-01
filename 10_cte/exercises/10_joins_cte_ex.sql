/* This file is full of practical exercises that will help you in building up your advanced SQL skills.
 */
SELECT * FROM flights
SELECT * FROM airports  
/* Q1. What's the highest number of flights that have departed in a day from an airport above altitude 7800?
 * 	   Please provide the query and answer below.*/

WITH Total_1 as(
SELECT
	f.flight_date,
	count(*) AS Tot_Num_flight
FROM
	flights AS f
JOIN airports AS a ON
	f.origin = a.faa
WHERE
	a.alt > 7800
	AND f.cancelled = 0
GROUP BY
	f.flight_date
	),
Max_1 AS (
SELECT 
	Max(Tot_Num_flight) AS Max_Flights
FROM 
	Total_1 
)
SELECT t.flight_date, m.Max_Flights
FROM Total_1 t
JOIN Max_1 m ON t.Tot_Num_flight = m.Max_Flights;





/* Q2. How many flights have departed and arrived in the United States?
 * 		Please provide the query and answer below.
 */


WITH USA_departures AS (
  SELECT
    a.country AS dep_country,
    COUNT(*) AS dep_count
  FROM flights f
  JOIN airports a ON f.origin = a.faa
  WHERE a.country = 'United States' AND f.cancelled = 0
  GROUP BY a.country
),
USA_arrivals AS (
  SELECT
    b.country AS arr_country,
    COUNT(*) AS arr_count
  FROM flights f
  JOIN airports b ON f.dest = b.faa
  WHERE b.country = 'United States' AND f.cancelled = 0
  GROUP BY b.country
)
SELECT
  d.dep_country,
  d.dep_count,
  a.arr_country,
  a.arr_count
FROM USA_departures d
JOIN USA_arrivals a ON d.dep_country = a.arr_country;






 /* Q3. Which flight had the highest departure delay?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which day and in which city?   
 * 	    Answer all questions with a single query.
 */


WITH max_delay_value AS (
  SELECT MAX(dep_delay) AS max_delay
  FROM flights
  WHERE cancelled = 0
),
max_delay_flight AS (
  SELECT 
    f.flight_date,
    f.dep_delay,
    f.tail_number,
    f.origin
  FROM flights f
  JOIN max_delay_value m ON f.dep_delay = m.max_delay
  WHERE f.cancelled = 0
)
SELECT 
  m.flight_date,
  m.dep_delay AS max_delay,
  m.tail_number,
  a.city,
  m.origin
FROM max_delay_flight m
JOIN airports a ON m.origin = a.faa
LIMIT 1;



SELECT 
    f.flight_date,
    f.dep_delay AS highest_delay,
    f.tail_number,
    a.city,
    f.origin
FROM flights f
JOIN airports a ON f.origin = a.faa
WHERE f.dep_delay = (
    SELECT MAX(dep_delay)
    FROM flights
    WHERE cancelled = 0
)
LIMIT 1;

/* Q4. What's the flight connection that covers the shortest distance?
 * 	   Please provide a list with 5 columns: 
 *     - origin_airport = The full name of the origin airport
 * 	   - origin_country = The country of the origin airport
 * 	   - destination_airport = The full name of the destination airport
 * 	   - destination_country = The country of the destination airport
 * 	   - smallest_distance = The flight distance between origin_airport and destination_airport
 * 	   Remember: Only provide the flight connection with the shortest distance of all flights in the flights table.
 * 	   Please provide the query below.
 */


SELECT f.origin AS origin_airport, a.country AS origin_country, dest AS destination_airport, b.country AS destination_country, Min(distance) AS smallest_distance FROM flights f
 JOIN airports a ON f.origin = a.faa JOIN airports b ON f.dest = b.faa WHERE cancelled = 0 GROUP BY origin_airport, origin_country, destination_airport, destination_country 
 ORDER BY smallest_distance LIMIT 1


WITH min_distance AS (
  SELECT MIN(distance) AS smallest_distance
  FROM flights
  WHERE distance > 0
),
shortest_flight AS (
  SELECT 
    f.origin,
    f.dest,
    f.distance
  FROM flights f
  JOIN min_distance m ON f.distance = m.smallest_distance
  LIMIT 1
)
SELECT 
  a.name AS origin_airport,
  a.country AS origin_country,
  b.name AS destination_airport,
  b.country AS destination_country,
  ff.distance AS smallest_distance
FROM shortest_flight ff
JOIN airports a ON ff.origin = a.faa
JOIN airports b ON ff.dest = b.faa;

dept delay 

SELECT f.flight_date,
	   f.flight_number,
	   f.dep_delay,
	   f.tail_number,
	   a.city
FROM flights f
INNER JOIN airports a
ON a.faa = f.origin
WHERE f.dep_delay = (SELECT MAX(dep_delay) FROM flights)


