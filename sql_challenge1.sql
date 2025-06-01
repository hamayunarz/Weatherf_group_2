/*
-------------------------------------
Challenge: Is the `actual_elapsed_time` column accurate?
-------------------------------------

As a Data Analyst, it's essential to assess the reliability of your data before using it to drive business decisions.

The `actual_elapsed_time` column in the `flights` table represents the time elapsed from departure to arrival. 
However, it's unlikely this value is captured via a running timer—it’s probably computed after the flight. 

In this challenge, you will verify how accurate this column is by:
- Investigating missing data
- Performing your own duration calculations
- Comparing them with the `actual_elapsed_time` values
- Considering complications like time zones and overnight flights
*/

/* 
Step 1: Check Data Availability

How complete is our data? Let's count the total rows and how many have missing or present values 
for the columns we care about.
*/

SELECT 'Total rows' AS metric, COUNT(*) AS value FROM flights
UNION ALL
SELECT 'Rows with actual_elapsed_time', COUNT(actual_elapsed_time) FROM flights
UNION ALL
SELECT 'Rows with dep_time', COUNT(dep_time) FROM flights
UNION ALL
SELECT 'Rows with arr_time', COUNT(arr_time) FROM flights
UNION ALL
SELECT 'Arrivals with no actual_elapsed_time', COUNT(*) FROM flights WHERE arr_time IS NOT NULL AND actual_elapsed_time IS NULL
UNION ALL
SELECT 'Diverted flights', COUNT(*) FROM flights WHERE diverted = 1
UNION ALL
SELECT 'Diverted flights with no actual_elapsed_time', COUNT(*) FROM flights WHERE diverted = 1 AND actual_elapsed_time IS NULL
UNION ALL
SELECT 'Non-diverted arrivals', COUNT(*) FROM flights WHERE diverted = 0 AND arr_time IS NOT NULL;


/*
Step 2.1: Understanding the columns

We’ll be using the following columns:
- dep_time
- arr_time
- actual_elapsed_time

dep_time: Departure time of the flight in HHMM format.
arr_time: Arrival time of the flight in HHMM format.
actual_elapsed_time: Total time (in minutes) from the departure to the arrival, calculated after the
Before jumping into SQL, write down your assumptions:



Write your assumptions here:
*/

-- dep_time is ...
-- arr_time is ...
-- actual_elapsed_time is ...

/*
Step 2.2: Explore unique values and order

Run three queries to inspect unique values in each column (ascending/descending) 
and validate whether your assumptions were correct.
*/

-- Example:
SELECT DISTINCT dep_time FROM flights ORDER BY dep_time ASC;
SELECT DISTINCT dep_time FROM flights ORDER BY dep_time ASC;
SELECT DISTINCT arr_time FROM flights ORDER BY arr_time ASC;
SELECT DISTINCT actual_elapsed_time FROM flights ORDER BY actual_elapsed_time ASC;


-- Do the same for arr_time and actual_elapsed_time.

-- What did you observe?
-- dep_time values look like...
-- arr_time values look like...
-- actual_elapsed_time values look like...

/*
Step 3.1: Calculate flight duration manually

Try calculating a `flight_duration` as the difference between `arr_time` and `dep_time`.
Is this straightforward? Write your query and insights below.
*/

-- Does it work? What's missing?
SELECT dep_time, arr_time, 
       arr_time - dep_time AS flight_duration_calculated
FROM flights
WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL;
/*
Step 3.2: Compare calculated flight_duration to actual_elapsed_time

Run a query that compares your calculated `flight_duration` with the `actual_elapsed_time`.
Explain whether they match and what the potential problems are.
*/
SELECT dep_time, arr_time, actual_elapsed_time, 
       (arr_time - dep_time) AS flight_duration_calculated,
       actual_elapsed_time - (arr_time - dep_time) AS difference
FROM flights
WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL AND actual_elapsed_time IS NOT NULL;
-- Query here:

-- Observations:
/*
- What problems did you notice?
- Why might simple subtraction not be enough?
*/

/*
Step 4: Convert raw time columns to usable formats

Convert:
- dep_time → dep_time_f (TIME)
- arr_time → arr_time_f (TIME)
- actual_elapsed_time → actual_elapsed_time_f (INTERVAL)

Also include basic flight info for reference.
*/

-- Query here:

SELECT dep_time, arr_time, 
       TO_TIMESTAMP(LPAD(dep_time::TEXT, 4, '0'), 'HH24MI')::TIME AS dep_time_f,
       TO_TIMESTAMP(LPAD(arr_time::TEXT, 4, '0'), 'HH24MI')::TIME AS arr_time_f,
       actual_elapsed_time
FROM flights
WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL AND actual_elapsed_time IS NOT NULL;
/*
Step 5.1: Calculate a new flight duration

*     This allows for quick prototyping and debugging and helps to understand how functions work. 
*     To optimize our query in terms of performance and readability,
*  we can always remove unneccessary columns in the end. 


Use the time-formatted columns to compute a new column: `flight_duration_f`.
*/

-- Hint: use your previous query 
-- SELECT ..., arr_time_f - dep_time_f AS flight_duration_f
-- FROM your_previous_query;

-- Query here:
SELECT dep_time_f, arr_time_f, 
       arr_time_f - dep_time_f AS flight_duration_f
FROM (
    SELECT dep_time, arr_time, 
           TO_TIMESTAMP(LPAD(dep_time::TEXT, 4, '0'), 'HH24MI')::TIME AS dep_time_f,
           TO_TIMESTAMP(LPAD(arr_time::TEXT, 4, '0'), 'HH24MI')::TIME AS arr_time_f
    FROM flights
    WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL
) AS formatted_times;

/*
Step 5.2: Compare calculated vs actual duration

Count how many values match vs total, and compute a match percentage.
*/


-- Hint: Use previous query
SELECT COUNT(*) AS total_flights,
       COUNT(CASE WHEN actual_elapsed_time = EXTRACT(EPOCH FROM arr_time_f - dep_time_f) / 60 THEN 1 END) AS match_count,
       (COUNT(CASE WHEN actual_elapsed_time = EXTRACT(EPOCH FROM arr_time_f - dep_time_f) / 60 THEN 1 END) * 100.0) / COUNT(*) AS match_percentage
FROM (
    SELECT dep_time, arr_time, actual_elapsed_time, 
           TO_TIMESTAMP(LPAD(dep_time::TEXT, 4, '0'), 'HH24MI')::TIME AS dep_time_f,
           TO_TIMESTAMP(LPAD(arr_time::TEXT, 4, '0'), 'HH24MI')::TIME AS arr_time_f
    FROM flights
    WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL AND actual_elapsed_time IS NOT NULL
) AS formatted_times;

/*
Step 5.3: Why do many values not match?

Write possible explanations:
- Are time zones an issue?
- Are overnight flights causing problems?
*/


Possible explanations:

Time zones: The flight times may be in different time zones, affecting the arr_time and dep_time calculation.
Overnight flights: If a flight departs before midnight and arrives after midnight, the time difference will be negative, causing discrepancies in the calculated flight duration.


/*

Step 6.1: Adjust for time zones
 *     To make sure the dep_time and arr_time values are all in the same time zone 
 * 			we need to know in which time zone they are.
 *     Take your query from exercise 5.1 and add the time zone values from the airports table.
 * 	   Make sure to transform them to INTERVAL and change their names to origin_tz and dest_tz.

Join the `airports` table (if available) and add origin_tz and dest_tz.
Convert dep_time_f and arr_time_f to UTC.
*/

-


SELECT dep_time_f, arr_time_f, origin_tz, dest_tz
FROM flights
JOIN airports ON flights.origin_airport = airports.airport_code
WHERE dep_time_f IS NOT NULL AND arr_time_f IS NOT NULL;


/*
Step 6.2: Recalculate flight_duration in UTC
*/

-- SELECT ..., arr_time_f_utc - dep_time_f_utc AS flight_duration_f_utc FROM ...


SELECT dep_time_f_utc, arr_time_f_utc, 
       arr_time_f_utc - dep_time_f_utc AS flight_duration_f_utc
FROM flights
WHERE dep_time_f_utc IS NOT NULL AND arr_time_f_utc IS NOT NULL;

/*
Step 6.3: Recalculate match rate using UTC values

What is the new match percentage after adjusting for time zones?
Why did it increase?
*/


SELECT COUNT(*) AS total_flights,
       COUNT(CASE WHEN actual_elapsed_time = EXTRACT(EPOCH FROM arr_time_f_utc - dep_time_f_utc) / 60 THEN 1 END) AS match_count,
       (COUNT(CASE WHEN actual_elapsed_time = EXTRACT(EPOCH FROM arr_time_f_utc - dep_time_f_utc) / 60 THEN 1 END) * 100.0) / COUNT(*) AS match_percentage
FROM flights
WHERE dep_time_f_utc IS NOT NULL AND arr_time_f_utc IS NOT NULL;

/*
Step 7.1: Handle overnight flights

What happens to flight_duration when a flight departs before midnight and arrives after midnight?
Use ORDER BY to look for negative durations.
*/

-- SELECT ... ORDER BY flight_duration_f_utc ASC;

-- Observations: ...
SELECT dep_time_f_utc, arr_time_f_utc, arr_time_f_utc - dep_time_f_utc AS flight_duration_f_utc
FROM flights
ORDER BY flight_duration_f_utc ASC;
/*
Step 7.2: Count number of overnight flights
*/
SELECT COUNT(*) FROM flights WHERE arr_time_f_utc < dep_time_f_utc;
-- SELECT COUNT(*) FROM flights WHERE arr_time_f_utc < dep_time_f_utc;

/*
Step 7.3: Fix overnight flights with CASE WHEN
*/
SELECT 
    CASE 
        WHEN arr_time_f_utc < dep_time_f_utc THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
        ELSE arr_time_f_utc - dep_time_f_utc
    END AS flight_duration_f_utc
FROM flights;
-- Example:
-- CASE 
--   WHEN arr_time_f_utc < dep_time_f_utc 
--   THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
--   ELSE arr_time_f_utc - dep_time_f_utc
-- END AS flight_duration_f_utc

/*
Great! We now get >90% match. That’s a strong indication the column is reliable enough for analysis.
*/

/*
Bonus Analysis: Scheduled vs. Actual Duration

Business Question: Are scheduled flight durations generally shorter than actual elapsed times?
Which routes show the biggest difference?

Use:
- sched_dep_time
- sched_arr_time
- actual_elapsed_time

Only include routes with at least 30 flights in January.
Show:
- share of flights where actual > scheduled
- average difference per route
- rank by highest average difference
*/
-- Query to analyze scheduled vs. actual flight durations
SELECT route, AVG(sched_dep_time - sched_arr_time) AS avg_scheduled_duration,
       AVG(actual_elapsed_time) AS avg_actual_duration
FROM flights
WHERE route IS NOT NULL
GROUP BY route
ORDER BY avg_actual_duration DESC;
-- Final summary: What are your business recommendations?
