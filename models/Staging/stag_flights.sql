WITH source_flights AS (
    SELECT * FROM {{ source('group_2_project_weather', 'flights_all') }}
)

SELECT
    flight_date,
    origin,
    dest,
    airline,
    tail_number,
    flight_number,
    dep_time,
    sched_dep_time,
    dep_delay,
    arr_time,
    sched_arr_time,
    arr_delay,
    cancelled,
    diverted,
    distance,
    actual_elapsed_time
FROM source_flights