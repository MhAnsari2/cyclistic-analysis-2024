
DROP TABLE IF EXISTS `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data`;



-- calculate trip length, day of week, and month names.
CREATE TABLE `melodic-subject-477216-n5.Bike_Share_2024.cleaned_combined_data` AS
SELECT 
 
  a.ride_id,
  a.rideable_type,
  a.started_at,
  a.ended_at,

  -- ride length in minutes
  TIMESTAMP_DIFF(a.ended_at, a.started_at, SECOND) / 60.0 AS ride_length,

  --   text for the day of week
  CASE EXTRACT(DAYOFWEEK FROM a.started_at)
    WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON' WHEN 3 THEN 'TUE'
    WHEN 4 THEN 'WED' WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
    WHEN 7 THEN 'SAT'
  END AS day_of_week,

  --   text for month names
  CASE EXTRACT(MONTH FROM a.started_at)
    WHEN 1 THEN 'JAN' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'APR'
    WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AUG'
    WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DEC'
  END AS month,

 
  a.start_station_name,
  a.end_station_name,
  a.start_lat,
  a.start_lng,
  a.end_lat,
  a.end_lng,

  a.member_casual


FROM `melodic-subject-477216-n5.Bike_Share_2024.combined_data` a

-- cleaning data.
WHERE 
  --missing start or end times
  a.started_at IS NOT NULL
  AND a.ended_at IS NOT NULL

  -- missing start or end station names
  AND a.start_station_name IS NOT NULL
  AND a.end_station_name   IS NOT NULL

  -- rides with no end coordinates (end_lat/lng)
  AND a.end_lat IS NOT NULL
  AND a.end_lng IS NOT NULL

  -- removing unreasonable trip lengths:
  -- 1 minute or longer, and less than 24 hours
  AND TIMESTAMP_DIFF(a.ended_at, a.started_at, SECOND) >= 60
  AND TIMESTAMP_DIFF(a.ended_at, a.started_at, SECOND) <  86400

  -- Keeping only valid categories for bikes and riders
  AND a.rideable_type IN ('classic_bike','electric_bike','docked_bike')
  AND a.member_casual IN ('member','casual');
