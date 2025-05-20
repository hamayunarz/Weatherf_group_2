WITH airports_reorder AS (
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
    FROM {{ref('stag_airports')}}
)
SELECT * FROM airports_reorder