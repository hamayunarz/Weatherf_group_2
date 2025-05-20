WITH flights AS (
  SELECT
    flight_date,
    origin,
    dest,
    airline,
    tail_number,
    flight_number,
    dep_time,
    air_time,
    sched_dep_time,
    dep_delay,
    arr_time,
    sched_arr_time,
    arr_delay,
    cancelled,
    diverted,
    distance,
    actual_elapsed_time
  FROM {{ ref('stag_flights') }}
),
airports AS (
  SELECT
    country,
        faa,
        name,
        lat,
        lon,
        alt,
        tz,
        dst,
        city
  FROM {{ ref('stag_airports') }}
  WHERE faa IN ('MCO', 'TPA', 'DAB', 'SRQ', 'PIE')
)
SELECT
  f.*
FROM flights f
INNER JOIN airports a
  ON f.origin = a.faa