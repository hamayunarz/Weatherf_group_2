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