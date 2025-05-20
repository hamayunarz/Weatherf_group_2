WITH flights AS (
  SELECT * FROM {{ ref('prep_flight_join') }}
),
weather_daily AS (
  SELECT 
    airport_code,
    date,
    avg_temp_c,
    precipitation_mm AS daily_prcp_mm,
    avg_wind_direction,
    avg_wind_speed_kmh,
    wind_peakgust_kmh AS daily_peak_gust_kmh,
    avg_pressure_hpa,
    sun_minutes
  FROM {{ ref('stag_weather_daily') }}
),
weather_hourly AS (
  SELECT
    airport_code,
    DATE(timestamp) AS date,
    EXTRACT(HOUR FROM timestamp) AS hour,
    temp_c,
    dewpoint_c,
    humidity_perc,
    precipitation_mm AS hourly_prcp_mm,
    snow_mm,
    wind_direction,
    wind_speed_kmh AS hourly_wind_speed_kmh,
    wind_peakgust_kmh AS hourly_peak_gust_kmh,
    pressure_hpa,
    sun_minutes,
    condition_code
  FROM {{ ref('stag_weather_hourly') }}
),
hourly_departure_weather AS (
  SELECT
    airport_code,
    date,
    hour,
    AVG(temp_c) AS avg_temp_c_hour,
    MAX(temp_c) AS max_temp_c_hour,
    MIN(temp_c) AS min_temp_c_hour,
    SUM(hourly_prcp_mm) AS prcp_mm_hour,
    SUM(snow_mm) AS snow_mm_hour,
    AVG(hourly_wind_speed_kmh) AS avg_wind_speed_kmh_hour,
    MAX(hourly_peak_gust_kmh) AS max_wind_gust_kmh_hour,
    COUNT(CASE WHEN condition_code IN (95, 96, 97, 98, 99) THEN 1 END) AS thunderstorm_hours,
    COUNT(CASE WHEN condition_code IN (71, 73, 75, 77, 85, 86) THEN 1 END) AS snow_hours,
    COUNT(CASE WHEN condition_code IN (51, 53, 55, 61, 63, 65, 80, 81, 82) THEN 1 END) AS rain_hours
  FROM weather_hourly
  GROUP BY airport_code, date, hour
)
SELECT
  f.flight_date,
  f.origin AS airport_code,
  f.airline, 
  f.tail_number,
  f.flight_number,
  f.dest AS destination,
  f.dep_time,
  f.sched_dep_time,
  f.dep_delay,
  f.arr_time,
  f.sched_arr_time,
  f.arr_delay,
  f.cancelled,
  f.diverted,
  f.distance,
  f.actual_elapsed_time,
  CASE 
    WHEN f.dep_time IS NOT NULL THEN FLOOR(f.dep_time / 100)
    ELSE NULL 
  END AS departure_hour,
  wd.avg_temp_c,
  wd.daily_prcp_mm,
  wd.avg_wind_direction,
  wd.avg_wind_speed_kmh,
  wd.daily_peak_gust_kmh,
  wd.avg_pressure_hpa,
  wd.sun_minutes AS daily_sun_minutes,
  hdw.avg_temp_c_hour,
  hdw.prcp_mm_hour,
  hdw.snow_mm_hour,
  hdw.avg_wind_speed_kmh_hour,
  hdw.max_wind_gust_kmh_hour,
  hdw.thunderstorm_hours,
  hdw.snow_hours,
  hdw.rain_hours
FROM flights f
LEFT JOIN weather_daily wd
  ON f.origin = wd.airport_code
  AND f.flight_date = wd.date
LEFT JOIN hourly_departure_weather hdw
  ON f.origin = hdw.airport_code
  AND f.flight_date = hdw.date
  AND CASE 
    WHEN f.dep_time IS NOT NULL THEN FLOOR(f.dep_time / 100)
    ELSE NULL 
  END = hdw.hour