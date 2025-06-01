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
SELECT * FROM weather_daily_raw


SELECT * FROM flights WHERE diverted = 1

SELECT * FROM flights WHERE dep_time IS NULL OR arr_time IS NULL OR actual_elapsed_time IS NULL;


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

Before jumping into SQL, write down your assumptions:

Write your assumptions here:
*/
The total number of rows is 1,658,259. However, the number of rows with actual_elapsed_time (1,626,052) = 32.207 incomplete record, - cancelled 28,511 = 3696 null

Non-diverted arrivals 1626052 = Rows with actual_elapsed_time 1626052
Diverted flights 3696 IS NOT added 

dep_time is higher than the number of rows with actual_elapsed_time + diverted flights = 954

Rows with dep_time: 1,630,702 - ows with arr_time: 1,629,231 = Difference: 1,471 


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
SELECT DISTINCT arr_time FROM flights ORDER BY arr_time desc;
SELECT DISTINCT actual_elapsed_time FROM flights ORDER BY actual_elapsed_time asc;
-- Do the same for arr_time and actual_elapsed_time.

-- What did you observe?
-- dep_time values look like...
-- arr_time values look like...
-- actual_elapsed_time values look like...

0001 to 2359
n 24-hour time, the valid range is 0000 (midnight) to 2359.
Action: Replace 2400 with 0000 (same as midnight).
1 should be 0001, 20 should be 0020
1. NULL, 2400 
Extremely short durations (< 15 minutes) or very long (> 12 hours) may need validation.
16 minutes): Could be valid for very short routes OR error 

/*
Step 3.1: Calculate flight duration manually

Try calculating a `flight_duration` as the difference between `arr_time` and `dep_time`.
Is this straightforward? Write your query and insights below.
*/

-- Does it work? What's missing?


SELECT dep_time, arr_time,  (arr_time - dep_time) AS naive_duratio FROM flights

SELECT
  dep_time,
  arr_time,
  actual_elapsed_time,
  CASE
    WHEN ((arr_time / 100) * 60 + (arr_time % 100)) <
         ((dep_time / 100) * 60 + (dep_time % 100))
    THEN ((arr_time / 100) * 60 + (arr_time % 100)) + 1440  -- add 24 hours
    ELSE ((arr_time / 100) * 60 + (arr_time % 100))
  END
  -
  ((dep_time / 100) * 60 + (dep_time % 100)) AS flight_duration
FROM flights
WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL ORDER BY flight_duration 

/*
 *
Step 3.2: Compare calculated flight_duration to actual_elapsed_time

Run a query that compares your calculated `flight_duration` with the `actual_elapsed_time`.
Explain whether they match and what the potential problems are.
*/

-- Query here:

SELECT dep_time, dep_delay, arr_delay, arr_time,  (arr_time - dep_time) AS naive_duratio, actual_elapsed_time, actual_elapsed_time - (
    CASE
      WHEN ((arr_time / 100) * 60 + (arr_time % 100)) <
           ((dep_time / 100) * 60 + (dep_time % 100))
      THEN ((arr_time / 100) * 60 + (arr_time % 100)) + 1440
      ELSE ((arr_time / 100) * 60 + (arr_time % 100))
    END
    -
    ((dep_time / 100) * 60 + (dep_time % 100))
  ) AS difference_from_recorded_elapsed_time
FROM flights
WHERE dep_time IS NOT NULL AND arr_time IS NOT NULL AND actual_elapsed_time IS NOT NULL
ORDER BY difference_from_recorded_elapsed_time DESC;


-- Observations:
/*
- What problems did you notice?
standardized across the entire system
- Why might simple subtraction not be enough?
*/
time ZONE 360 
/*
Step 4: Convert raw time columns to usable formats

Convert:
- dep_time → dep_time_f (TIME)
- arr_time → arr_time_f (TIME)
- actual_elapsed_time → actual_elapsed_time_f (INTERVAL)

Also include basic flight info for reference.
*/

-- Query here:
SELECT
    flight_date,
    flight_number,
    airline,
    tail_number,
    origin,
    dest,
    
    TO_TIMESTAMP(
        CASE 
            WHEN dep_time = 2400 THEN '0000' 
            ELSE LPAD(dep_time::TEXT, 4, '0') 
        END, 
        'HH24MI'
    )::TIME AS dep_time_f,
    
    TO_TIMESTAMP(
        CASE 
            WHEN arr_time = 2400 THEN '0000' 
            ELSE LPAD(arr_time::TEXT, 4, '0') 
        END, 
        'HH24MI'
    )::TIME AS arr_time_f,
    
    -- Convert actual_elapsed_time to actual_elapsed_time_f (INTERVAL)
    actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f
FROM flights
WHERE dep_time IS NOT NULL 
  AND arr_time IS NOT NULL 
  AND actual_elapsed_time IS NOT NULL
ORDER BY flight_date, flight_number;


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
WITH flights_formatted AS (
    SELECT
        flight_date,
        flight_number,
        airline,
        tail_number,
        origin,
        dest,
        
        TO_TIMESTAMP(
            CASE 
                WHEN dep_time = 2400 THEN '0000' 
                ELSE LPAD(dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN arr_time = 2400 THEN '0000' 
                ELSE LPAD(arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        -- Convert actual_elapsed_time to actual_elapsed_time_f (INTERVAL)
        actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f
    FROM flights
    WHERE dep_time IS NOT NULL 
      AND arr_time IS NOT NULL 
      AND actual_elapsed_time IS NOT NULL
)
SELECT 
    *,
    CASE
        WHEN arr_time_f < dep_time_f THEN 
            (arr_time_f + INTERVAL '24 hours') - dep_time_f
        ELSE 
            arr_time_f - dep_time_f
    END AS flight_duration_f
FROM flights_formatted;

/*
Step 5.2: Compare calculated vs actual duration

Count how many values match vs total, and compute a match percentage.
*/


-- Hint: Use previous query
WITH flights_with_duration AS (
    SELECT
        flight_date,
        flight_number,
        airline,
        tail_number,
        origin,
        dest,
        dep_time_f,
        arr_time_f,
        actual_elapsed_time_f,
        CASE
            WHEN arr_time_f < dep_time_f THEN 
                (arr_time_f + INTERVAL '24 hours') - dep_time_f
            ELSE 
                arr_time_f - dep_time_f
        END AS flight_duration_f
    FROM (
        SELECT
            flight_date,
            flight_number,
            airline,
            tail_number,
            origin,
            dest,
            
            TO_TIMESTAMP(
                CASE 
                    WHEN dep_time = 2400 THEN '0000' 
                    ELSE LPAD(dep_time::TEXT, 4, '0') 
                END, 
                'HH24MI'
            )::TIME AS dep_time_f,
            
            TO_TIMESTAMP(
                CASE 
                    WHEN arr_time = 2400 THEN '0000' 
                    ELSE LPAD(arr_time::TEXT, 4, '0') 
                END, 
                'HH24MI'
            )::TIME AS arr_time_f,
            
            actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f
        FROM flights
        WHERE dep_time IS NOT NULL 
          AND arr_time IS NOT NULL 
          AND actual_elapsed_time IS NOT NULL
    ) AS formatted_flights
)
SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END) AS matching_flights,
    ROUND(
        (SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END)::DECIMAL / COUNT(*)) * 100, 
        2
    ) AS match_percentage
FROM flights_with_duration;

/*
Step 5.3: Why do many values not match?

Write possible explanations:
- Are time zones an issue?
- Are overnight flights causing problems?
*/


Based on what we've seen so far, there are several likely explanations for mismatches:

Time Zone Issues: The dep_time and arr_time are probably local times for the departure and arrival airports, which may be in different time zones. Our simple subtraction doesn't account for this.
Overnight Flights: When flights cross midnight, a simple subtraction would show negative or very short durations, while the actual elapsed time would be much longer.
Data Quality Issues: There might be recording errors or inconsistencies in how the times are entered.
Taxiing Time: The actual_elapsed_time might include taxi time at both airports, while our calculation only considers air time between departure and arrival.

/*

Step 6.1: Adjust for time zones
 *     To make sure the dep_time and arr_time values are all in the same time zone 
 * 			we need to know in which time zone they are.
 *     Take your query from exercise 5.1 and add the time zone values from the airports table.
 * 	   Make sure to transform them to INTERVAL and change their names to origin_tz and dest_tz.

Join the `airports` table (if available) and add origin_tz and dest_tz.
Convert dep_time_f and arr_time_f to UTC.
*/
WITH flights_with_timezone AS (
    SELECT
        f.flight_date,
        f.flight_number,
        f.airline,
        f.tail_number,
        f.origin,
        f.dest,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.dep_time = 2400 THEN '0000' 
                ELSE LPAD(f.dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.arr_time = 2400 THEN '0000' 
                ELSE LPAD(f.arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        f.actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f,
        
        -- Convert timezone offsets to intervals
        (o.tz * INTERVAL '1 hour') AS origin_tz,
        (d.tz * INTERVAL '1 hour') AS dest_tz
        
    FROM flights f
    JOIN airports o ON f.origin = o.faa
    JOIN airports d ON f.dest = d.faa
    WHERE f.dep_time IS NOT NULL 
      AND f.arr_time IS NOT NULL 
      AND f.actual_elapsed_time IS NOT NULL
),
flights_with_utc AS (
    SELECT 
        *,
        -- Convert departure time to UTC
        dep_time_f - origin_tz AS dep_time_f_utc,
        -- Convert arrival time to UTC
        arr_time_f - dest_tz AS arr_time_f_utc
    FROM flights_with_timezone
)
SELECT
    *,
    CASE
        WHEN arr_time_f_utc < dep_time_f_utc THEN 
            (arr_time_f_utc + INTERVAL '24 hours') - dep_time_f_utc
        ELSE 
            arr_time_f_utc - dep_time_f_utc
    END AS flight_duration_f_utc
FROM flights_with_utc
LIMIT 100;
-- Limit to 100 rows for initial inspection


/*
Step 6.2: Recalculate flight_duration in UTC
*/

-- SELECT ..., arr_time_f_utc - dep_time_f_utc AS flight_duration_f_utc FROM ...


WITH flights_with_timezone AS (
    SELECT
        f.flight_date,
        f.flight_number,
        f.airline,
        f.tail_number,
        f.origin,
        f.dest,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.dep_time = 2400 THEN '0000' 
                ELSE LPAD(f.dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.arr_time = 2400 THEN '0000' 
                ELSE LPAD(f.arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        f.actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f,
        
        -- Convert timezone offsets to intervals
        (o.tz * INTERVAL '1 hour') AS origin_tz,
        (d.tz * INTERVAL '1 hour') AS dest_tz
        
    FROM flights f
    JOIN airports o ON f.origin = o.faa
    JOIN airports d ON f.dest = d.faa
    WHERE f.dep_time IS NOT NULL 
      AND f.arr_time IS NOT NULL 
      AND f.actual_elapsed_time IS NOT NULL
),
flights_with_utc AS (
    SELECT 
        *,
        -- Convert departure time to UTC
        dep_time_f - origin_tz AS dep_time_f_utc,
        -- Convert arrival time to UTC
        arr_time_f - dest_tz AS arr_time_f_utc
    FROM flights_with_timezone
),
flights_with_duration AS (
    SELECT
        *,
        -- Calculate flight duration in UTC, handling overnight flights
        CASE 
            WHEN arr_time_f_utc < dep_time_f_utc 
            THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
            ELSE arr_time_f_utc - dep_time_f_utc
        END AS flight_duration_f_utc
    FROM flights_with_utc
)
SELECT
    COUNT(*) AS total_flights,
    -- Count flights where the duration matches exactly
    SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f_utc)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END) AS exact_matches,
    -- Count flights where duration is within 5 minutes of actual_elapsed_time
    SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 5 THEN 1 ELSE 0 END) AS within_5min,
    -- Count flights where duration is within 10 minutes of actual_elapsed_time
    SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 10 THEN 1 ELSE 0 END) AS within_10min,
    -- Calculate match percentages
    ROUND(100.0 * SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f_utc)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_exact_match,
    ROUND(100.0 * SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_within_5min,
    ROUND(100.0 * SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 10 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_within_10min
FROM flights_with_duration;

/*
Step 6.3: Recalculate match rate using UTC values

What is the new match percentage after adjusting for time zones?
Why did it increase?
*/

WITH flights_with_timezone AS (
    SELECT
        f.flight_date,
        f.flight_number,
        f.airline,
        f.tail_number,
        f.origin,
        f.dest,
        
        -- Format departure and arrival times
        TO_TIMESTAMP(
            CASE 
                WHEN f.dep_time = 2400 THEN '0000' 
                ELSE LPAD(f.dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.arr_time = 2400 THEN '0000' 
                ELSE LPAD(f.arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        f.actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f,
        
        -- Convert timezone offsets to intervals
        (o.tz * INTERVAL '1 hour') AS origin_tz,
        (d.tz * INTERVAL '1 hour') AS dest_tz
    FROM flights f
    JOIN airports o ON f.origin = o.faa
    JOIN airports d ON f.dest = d.faa
    WHERE f.dep_time IS NOT NULL 
      AND f.arr_time IS NOT NULL 
      AND f.actual_elapsed_time IS NOT NULL
),
flights_with_utc AS (
    SELECT 
        *,
        -- Convert departure time to UTC
        dep_time_f - origin_tz AS dep_time_f_utc,
        -- Convert arrival time to UTC
        arr_time_f - dest_tz AS arr_time_f_utc
    FROM flights_with_timezone
),
flights_with_duration AS (
    SELECT
        *,
        -- Calculate flight duration in UTC, handling overnight flights
        CASE 
            WHEN arr_time_f_utc < dep_time_f_utc 
            THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
            ELSE arr_time_f_utc - dep_time_f_utc
        END AS flight_duration_f_utc
    FROM flights_with_utc
)
SELECT
    COUNT(*) AS total_flights,
    -- Count flights where the duration matches exactly
    SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f_utc)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END) AS exact_matches,
    -- Count flights where duration is within 5 minutes of actual_elapsed_time
    SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 5 THEN 1 ELSE 0 END) AS within_5min,
    -- Count flights where duration is within 10 minutes of actual_elapsed_time
    SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 10 THEN 1 ELSE 0 END) AS within_10min,
    -- Calculate match percentages
    ROUND(100.0 * SUM(CASE WHEN EXTRACT(EPOCH FROM flight_duration_f_utc)/60 = EXTRACT(EPOCH FROM actual_elapsed_time_f)/60 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_exact_match,
    ROUND(100.0 * SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_within_5min,
    ROUND(100.0 * SUM(CASE WHEN ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f)/60) <= 10 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_within_10min
FROM flights_with_duration;

/*
Step 7.1: Handle overnight flights

What happens to flight_duration when a flight departs before midnight and arrives after midnight?
Use ORDER BY to look for negative durations.
*/

-- SELECT ... ORDER BY flight_duration_f_utc ASC;


-- Observations: ...
WITH flights_with_timezone AS (
    SELECT
        f.flight_date,
        f.flight_number,
        f.airline,
        f.origin,
        f.dest,
        
        -- Format departure and arrival times
        TO_TIMESTAMP(
            CASE 
                WHEN f.dep_time = 2400 THEN '0000' 
                ELSE LPAD(f.dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.arr_time = 2400 THEN '0000' 
                ELSE LPAD(f.arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        f.actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f,
        
        -- Get timezone offsets
        (o.tz * INTERVAL '1 hour') AS origin_tz,
        (d.tz * INTERVAL '1 hour') AS dest_tz
        
    FROM flights f
    JOIN airports o ON f.origin = o.faa
    JOIN airports d ON f.dest = d.faa
    WHERE f.dep_time IS NOT NULL 
      AND f.arr_time IS NOT NULL 
      AND f.actual_elapsed_time IS NOT NULL
),
flights_with_utc AS (
    SELECT 
        *,
        -- Convert to UTC
        dep_time_f - origin_tz AS dep_time_f_utc,
        arr_time_f - dest_tz AS arr_time_f_utc
    FROM flights_with_timezone
)
SELECT
    COUNT(*) AS total_flights,
    COUNT(CASE WHEN arr_time_f_utc < dep_time_f_utc THEN 1 END) AS overnight_flights,
    ROUND(100.0 * COUNT(CASE WHEN arr_time_f_utc < dep_time_f_utc THEN 1 END) / COUNT(*), 2) AS pct_overnight
FROM flights_with_utc;
/*
Step 7.2: Count number of overnight flights
*/

-- SELECT COUNT(*) FROM flights WHERE arr_time_f_utc < dep_time_f_utc;
WITH flights_with_timezone AS (
    SELECT
        f.flight_date,
        f.flight_number,
        f.airline,
        f.tail_number,
        f.origin,
        f.dest,
        
        -- Format departure and arrival times
        TO_TIMESTAMP(
            CASE 
                WHEN f.dep_time = 2400 THEN '0000' 
                ELSE LPAD(f.dep_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS dep_time_f,
        
        TO_TIMESTAMP(
            CASE 
                WHEN f.arr_time = 2400 THEN '0000' 
                ELSE LPAD(f.arr_time::TEXT, 4, '0') 
            END, 
            'HH24MI'
        )::TIME AS arr_time_f,
        
        f.actual_elapsed_time * INTERVAL '1 minute' AS actual_elapsed_time_f,
        
        -- Convert timezone offsets to intervals
        (o.tz * INTERVAL '1 hour') AS origin_tz,
        (d.tz * INTERVAL '1 hour') AS dest_tz
        
    FROM flights f
    JOIN airports o ON f.origin = o.faa
    JOIN airports d ON f.dest = d.faa
    WHERE f.dep_time IS NOT NULL 
      AND f.arr_time IS NOT NULL 
      AND f.actual_elapsed_time IS NOT NULL
),
flights_with_utc AS (
    SELECT 
        *,
        -- Convert departure time to UTC
        dep_time_f - origin_tz AS dep_time_f_utc,
        -- Convert arrival time to UTC
        arr_time_f - dest_tz AS arr_time_f_utc
    FROM flights_with_timezone
),
flights_with_duration AS (
    SELECT
        *,
        -- Calculate flight duration in UTC, handling overnight flights
        CASE 
            WHEN arr_time_f_utc < dep_time_f_utc 
            THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
            ELSE arr_time_f_utc - dep_time_f_utc
        END AS flight_duration_f_utc
    FROM flights_with_utc
)
SELECT
    flight_date,
    flight_number,
    airline,
    origin,
    dest,
    dep_time_f,
    arr_time_f,
    dep_time_f_utc,
    arr_time_f_utc,
    actual_elapsed_time_f,
    flight_duration_f_utc,
    (EXTRACT(EPOCH FROM flight_duration_f_utc) - EXTRACT(EPOCH FROM actual_elapsed_time_f))/60 AS diff_minutes
FROM flights_with_duration
ORDER BY ABS(EXTRACT(EPOCH FROM flight_duration_f_utc - actual_elapsed_time_f))/60 DESC
LIMIT 20;
/*
Step 7.3: Fix overnight flights with CASE WHEN
*/

-- Example:
-- CASE 
--   WHEN arr_time_f_utc < dep_time_f_utc 
--   THEN (arr_time_f_utc + INTERVAL '1 day') - dep_time_f_utc
--   ELSE arr_time_f_utc - dep_time_f_utc
-- END AS flight_duration_f_utc

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

-- Final summary: What are your business recommendations?
Summary of Findings and Business Recommendations
Based on our analysis, here are the key findings and recommendations:

Data Quality Assessment:

The actual_elapsed_time column appears to be largely accurate when time zones and overnight flights are accounted for.
There are some discrepancies that should be monitored and potentially investigated.


Flight Planning Recommendations:

Routes with consistently higher actual durations than scheduled should be reviewed for scheduling adjustments.
Airlines may need to add buffer time to routes that frequently exceed their scheduled duration.


Operational Improvements:

Focus on routes with the largest discrepancies between scheduled and actual flight times.
Consider whether certain airports or times of day contribute more to delays.


Data System Improvements:

Implement automatic time zone conversions in the database to simplify analysis.
Add validation checks for flight durations that seem implausible.


Customer Communication:

For routes where actual times frequently exceed scheduled times, consider setting more accurate expectations with passengers.
Business Recommendations:

Which routes need schedule adjustments?
Are there specific airports where flights consistently exceed their scheduled durations?
What changes would improve operational efficiency?



Tips for Creative Analysis

Visualize the Data: Consider creating visualizations to spot patterns:

Scatterplots of calculated vs. recorded durations
Histograms of duration differences
Heatmaps of routes with the most discrepancies


Explore External Factors:

Does the day of week affect duration accuracy?
Are there seasonal patterns?
Do specific airlines show more discrepancies?


Advanced Techniques:

Try clustering flights by duration accuracy
Look for correlations with other variables like distance or departure time
Calculate confidence intervals for the accuracy assessments
