
-- 1) Commute vs Leisure by membership
--    Taking weekdays 07am–09am & 16pm–19pm as commute; everything else = leisure.

WITH t AS (
  SELECT
    member_casual,
    EXTRACT(DAYOFWEEK FROM started_at) AS dow,         -- 1=Sun,...,7=Sat
    EXTRACT(HOUR FROM started_at)      AS hr
  FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
)
SELECT
  member_casual,
  SUM(CASE WHEN dow BETWEEN 2 AND 6 AND (hr BETWEEN 7 AND 9 OR hr BETWEEN 16 AND 19) THEN 1 ELSE 0 END) AS commute_trips,
  SUM(CASE WHEN NOT (dow BETWEEN 2 AND 6 AND (hr BETWEEN 7 AND 9 OR hr BETWEEN 16 AND 19)) THEN 1 ELSE 0 END) AS leisure_trips
FROM t
GROUP BY member_casual;


-- 2) Weekend Index by membership
--    Weekend Index = weekend trips / weekday trips
--    Higher index => more leisure-based usage.

WITH w AS (
  SELECT
    member_casual,
    CASE WHEN EXTRACT(DAYOFWEEK FROM started_at) IN (1,7) THEN 'weekend' ELSE 'weekday' END AS day_type
  FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
)
SELECT
  member_casual,
  SUM(CASE WHEN day_type='weekend' THEN 1 ELSE 0 END) AS weekend_trips,
  SUM(CASE WHEN day_type='weekday' THEN 1 ELSE 0 END) AS weekday_trips,
  SAFE_DIVIDE(
    SUM(CASE WHEN day_type='weekend' THEN 1 ELSE 0 END),
    NULLIF(SUM(CASE WHEN day_type='weekday' THEN 1 ELSE 0 END),0)
  ) AS weekend_index
FROM w
GROUP BY member_casual;

-- 3) duration comparison by membership (median & p90)
--    Averages get distorted by outliers; percentiles are more reliable.

SELECT
  member_casual,
  APPROX_QUANTILES(ride_length, 100)[SAFE_OFFSET(50)] AS median_min,
  APPROX_QUANTILES(ride_length, 10)[SAFE_OFFSET(9)]   AS p90_min,
  COUNT(*) AS trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
GROUP BY member_casual
ORDER BY trips DESC;


-- 4) Long-ride share (> 30 minutes) by month & membership
--    Shows who tends to take recreational-length rides and when.

WITH m AS (
  SELECT
    member_casual,
    FORMAT_DATE('%Y-%m', DATE(started_at)) AS y_m,   -- year-month label
    ride_length
  FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
)
SELECT
  y_m,
  member_casual,
  COUNT(*) AS total_trips,
  COUNTIF(ride_length > 30) AS long_trips,
  SAFE_DIVIDE(COUNTIF(ride_length > 30), NULLIF(COUNT(*),0)) AS long_share
FROM m
GROUP BY y_m, member_casual
ORDER BY y_m, member_casual;

-- 5) Bike-type preference by time frame (commute vs leisure)
--    When would each bike type be used more often

WITH b AS (
  SELECT
    member_casual,
    rideable_type,
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM started_at) BETWEEN 2 AND 6
           AND (EXTRACT(HOUR FROM started_at) BETWEEN 7 AND 9 OR EXTRACT(HOUR FROM started_at) BETWEEN 16 AND 19)
        THEN 'commute'
      ELSE 'leisure'
    END AS time_bucket
  FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
)
SELECT
  time_bucket,
  member_casual,
  rideable_type,
  COUNT(*) AS trips
FROM b
GROUP BY time_bucket, member_casual, rideable_type
ORDER BY time_bucket, member_casual, trips DESC;


-- 6) Repeated route patterns (start->end pairs) by membership type.
--    Recognizing habitual commuting (same origin/destination pairs).
--    We count how often the *same* pair repeats and show the top 10.

WITH r AS (
  SELECT
    member_casual,
    start_station_name,
    end_station_name,
    COUNT(*) AS trips
  FROM `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`
  WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
  GROUP BY member_casual, start_station_name, end_station_name
),
ranked AS (
  SELECT
    r.*,
    ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY trips DESC) AS rn
  FROM r
)
SELECT
  member_casual,
  start_station_name,
  end_station_name,
  trips
FROM ranked
WHERE rn <= 10
ORDER BY member_casual, trips DESC;
