-- 1) Schema
SELECT column_name, data_type
FROM  `melodic-subject-477216-n5.Bike_Share_2024.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'combined_data'
ORDER BY ordinal_position;

-- 2) Null counts (any missing)
SELECT
  COUNT(*) - COUNT(ride_id)            AS ride_id,
  COUNT(*) - COUNT(rideable_type)      AS rideable_type,
  COUNT(*) - COUNT(started_at)         AS started_at,
  COUNT(*) - COUNT(ended_at)           AS ended_at,
  COUNT(*) - COUNT(start_station_name) AS start_station_name,
  COUNT(*) - COUNT(start_station_id)   AS start_station_id,
  COUNT(*) - COUNT(end_station_name)   AS end_station_name,
  COUNT(*) - COUNT(end_station_id)     AS end_station_id,
  COUNT(*) - COUNT(start_lat)          AS start_lat,
  COUNT(*) - COUNT(start_lng)          AS start_lng,
  COUNT(*) - COUNT(end_lat)            AS end_lat,
  COUNT(*) - COUNT(end_lng)            AS end_lng,
  COUNT(*) - COUNT(member_casual)      AS member_casual
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`;

-- 3) Duplicates by ride_id
SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`;

-- 4) ride_id length check
SELECT LENGTH(ride_id) AS length_ride_id, COUNT(*) AS no_of_rows
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY length_ride_id
ORDER BY no_of_rows DESC;

-- 5) Unique bike types
SELECT rideable_type, COUNT(*) AS no_of_trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY rideable_type
ORDER BY no_of_trips DESC;

-- 6) Duration sanity using TIMESTAMP_DIFF
WITH dur AS (
  SELECT
    ride_id,
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS s
  FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
)
SELECT
  COUNTIF(s IS NULL)    AS null_duration,
  COUNTIF(s < 0)        AS negative_duration,
  COUNTIF(s = 0)        AS zero_duration,
  COUNTIF(s < 60)       AS under_1_min,
  COUNTIF(s >= 86400)   AS over_24h,
  APPROX_QUANTILES(s, 5) AS duration_quintiles_sec
FROM dur;

-- 7) “Both missing” vs “any missing”
-- Both start fields missing
SELECT COUNT(*) AS both_start_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE start_station_name IS NULL AND start_station_id IS NULL;

-- Any start field missing
SELECT COUNT(*) AS any_start_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE start_station_name IS NULL OR start_station_id IS NULL;

-- Both end fields missing
SELECT COUNT(*) AS both_end_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE end_station_name IS NULL AND end_station_id IS NULL;

-- Any end field missing
SELECT COUNT(*) AS any_end_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE end_station_name IS NULL OR end_station_id IS NULL;

-- End/START lat/lng any missing
SELECT COUNT(*) AS end_coord_any_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE end_lat IS NULL OR end_lng IS NULL;

SELECT COUNT(*) AS start_coord_any_missing
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
WHERE start_lat IS NULL OR start_lng IS NULL;

-- 8) Member vs casual counts
SELECT member_casual, COUNT(*) AS trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY member_casual
ORDER BY trips DESC;

-- 9) activity distribution
SELECT EXTRACT(MONTH FROM started_at) AS month, COUNT(*) AS trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY month
ORDER BY month;

SELECT EXTRACT(DAYOFWEEK FROM started_at) AS dow, COUNT(*) AS trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY dow
ORDER BY dow;

SELECT EXTRACT(HOUR FROM started_at) AS hr, COUNT(*) AS trips
FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data`
GROUP BY hr
ORDER BY hr;
