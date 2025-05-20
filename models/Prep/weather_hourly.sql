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