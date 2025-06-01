/* Airport Stats
 *
 * In one table, show per airport in separate columns:
 *  - count of departures 
 *  - count of arrivals 
 *
 * BONUS: what other stats can be added?
 */


SELECT * FROM airports WHERE faa = 'ATL'
SELECT * FROM flights WHERE origin = 'OGG'




SELECT a.name AS Airport_dep,count(f.*) AS Dep_count,b.name AS Airport_arr, count(f.*) AS Arr_coount
FROM flights f JOIN airports a ON f.origin = a.faa JOIN airports b ON f.dest = b.faa WHERE f.cancelled = 0 AND a.FAA = 'BNA'
GROUP BY a.name, b.name ORDER BY Dep_count 

WITH origin_count AS (
	SELECT flight_date,
		   origin AS airport, 
		   COUNT(*) AS depatures_per_day
	FROM flights
	WHERE cancelled = 0
	GROUP BY flight_date, origin
),
dest_count AS (
	SELECT flight_date,
		   dest AS airport, 
		   COUNT(*) AS arrivals_per_day
	FROM flights
		WHERE cancelled = 0
	GROUP BY flight_date, dest
)
SELECT *
FROM origin_count
JOIN dest_count
USING (airport, flight_date) WHERE airport = 'BNA' 


SELECT 
  a.faa AS airport_code,
  a.name AS airport_name,
  COUNT(f_dep.dep_time) AS departures,
  COUNT(f_arr.arr_time) AS arrivals
FROM airports a
LEFT JOIN flights f_dep ON a.faa = f_dep.origin
LEFT JOIN flights f_arr ON a.faa = f_arr.dest
GROUP BY a.faa, a.name
ORDER BY a.faa;


SELECT a. name, f.dest, f.origin,
•name, count (*)
FROM TLIOnTS AS T
Join alroorts as a on t.dest = a.taa
GROUP BY
forigin,
f.dest, a. name,
ORDER BY count (*) desc
-cte?
Ist cre
WITH counted routes AS
SELECT origin,
dest, count(*) AS flight_count
FROM Flahts
GROUP BY origin,
dest
2nd CTE
routes AS (
SELECT *
FROM counted_routes
OkbEk by tilont count desc
SELECT t_r.origin,
FROM top.
airports
JOIN airports
Er dest, tr.flight_count
r. des
oN Er.oragin Ta2.



/* Solve the Q11. question from JOINs exercise in  "09_joins_ex_airports.sql" 
 * but now with CTEs:
 *
 *      Q11. Find city names with :
 * 		        - the most daily total departures
 * 		        - the most daily unique planes departed
 * 		        - the most daily unique airlines
 *
 * We can use CTE to make it easier to understand the query. But, there is no "The best way."
 *
 * We can adapt the 3 Steps we did using Views, but now with CTEs:
 *      1. Calculate counts (departures, tails, airlines) per flight date and city. 
                (Hint: filter out cancelled flights)
 * 		2. (Querying from the 1st CTE) Find the max daily values over all for counts of departures, tails and airlines
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
	
	
	
	
	
DROP VIEW IF EXISTS VIEW1

CREATE OR REPLACE VIEW view1 AS	
WITH Most_1 AS (
  SELECT
    a.city,
    f.flight_date,
    COUNT(*) AS Most_daily,
    COUNT(DISTINCT f.tail_number) AS Daily_Unique_Plane,
    COUNT(DISTINCT f.airline) AS Unique_Airline
  FROM flights f
  JOIN airports a ON f.origin = a.faa
  WHERE f.cancelled = 0
  GROUP BY a.city, f.flight_date
),
Max_1 AS (
  SELECT
    MAX(Most_daily) AS Max_Daily_Departures,
    MAX(Daily_Unique_Plane) AS Max_Daily_Planes,
    MAX(Unique_Airline) AS Max_Daily_Airlines
  FROM Most_1
)
SELECT 
  m.city,
  MAX(m.Most_daily) AS Max_Daily,
  MAX(m.Daily_Unique_Plane) AS Max_Unique_Plane,
  Max(m.Unique_Airline) AS Unique_Airlin
FROM Most_1 m
JOIN Max_1 mm
  ON m.Most_daily = mm.Max_Daily_Departures
     OR m.Daily_Unique_Plane = mm.Max_Daily_Planes
     OR m.Unique_Airline = mm.Max_Daily_Airlines
     GROUP BY m.city
ORDER BY m.city;

SELECT * FROM view1;


