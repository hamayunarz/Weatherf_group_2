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
  FROM {{ ref('weather_hourly') }}
  GROUP BY airport_code, date, hour