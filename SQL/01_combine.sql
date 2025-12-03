-- Delete old combined table if it exists
DROP TABLE IF EXISTS `melodic-subject-477216-n5.Bike_Share_2024.combined_data`;

-- Combine all 12 monthly tables for 2024
CREATE TABLE `melodic-subject-477216-n5.Bike_Share_2024.combined_data` AS
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202401-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202402-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202403-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202404-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202405-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202406-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202407-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202408-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202409-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202410-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202411-divvy-tripdata`
UNION ALL
SELECT * FROM `melodic-subject-477216-n5.Bike_Share_2024.202412-divvy-tripdata`;