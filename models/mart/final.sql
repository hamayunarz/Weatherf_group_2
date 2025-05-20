SELECT
  f.flight_date,
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
FROM {{ ref('flights') }} f
LEFT JOIN {{ ref('weather_daily') }} wd
  ON f.origin = wd.airport_code
  AND f.flight_date = wd.date
LEFT JOIN {{ ref('hourly_departure_weather') }} hdw
  ON f.origin = hdw.airport_code
  AND f.flight_date = hdw.date
  AND CASE 
    WHEN f.dep_time IS NOT NULL THEN FLOOR(f.dep_time / 100)
    ELSE NULL 
  END = hdw.hour