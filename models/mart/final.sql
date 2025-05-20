SELECT
  f.flight_date,
  f.origin AS origin_airport_code,
  f.lat AS origin_airport_latitude,
  f.alt AS origin_airport_altitude,
  f.lon AS origin_airport_longitude,
  f.tz AS origin_airport_timezone,
  CASE
     WHEN f.alt > 5000 THEN 'high_altitude'
     WHEN f.alt BETWEEN 2000 AND 5000 THEN 'medium_altitude'
     ELSE 'low_altitude'
  END AS origin_altitude_category,
  f.airline,
  f.tail_number,
  f.flight_number,
  f.dest AS destination_airport_code,
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
  hdw_origin.avg_temp_c_hour AS origin_avg_temp_c_hour,
  hdw_origin.prcp_mm_hour AS origin_prcp_mm_hour,
  hdw_origin.snow_mm_hour AS origin_snow_mm_hour,
  hdw_origin.avg_wind_speed_kmh_hour AS origin_avg_wind_speed_kmh_hour,
  hdw_origin.max_wind_gust_kmh_hour AS origin_max_wind_gust_kmh_hour,
  hdw_origin.thunderstorm_hours AS origin_thunderstorm_hours,
  hdw_origin.snow_hours AS origin_snow_hours,
  hdw_origin.rain_hours AS origin_rain_hours
FROM {{ ref('flights') }} f
LEFT JOIN {{ ref('hourly_departure_weather') }} hdw_origin
  ON f.origin = hdw_origin.airport_code
  AND f.flight_date = hdw_origin.date
  AND CASE
    WHEN f.dep_time IS NOT NULL THEN FLOOR(f.dep_time / 100)
    ELSE NULL
  END = hdw_origin.hour
LEFT JOIN {{ ref('hourly_departure_weather') }} hdw_dest
  ON f.dest = hdw_dest.airport_code
  AND f.flight_date = hdw_dest.date
  AND CASE
    WHEN f.sched_arr_time IS NOT NULL THEN FLOOR(f.sched_arr_time / 100)
    ELSE NULL
  END = hdw_dest.hour


