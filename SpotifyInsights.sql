--Spotify Datasets
--1. Create the Database & Table
DROP TABLE IF EXISTS Spotify;
CREATE TABLE Spotify (
    spotify_track_uri TEXT,
    ts TIMESTAMP,
    platform TEXT,
    ms_played INT,
    track_name TEXT,
    artist_name TEXT,
    album_name TEXT,
    reason_start TEXT,
    reason_end TEXT,
    shuffle BOOLEAN,
    skipped BOOLEAN
);

--Data Cleaning & Transformation
SELECT * FROM spotify WHERE track_name IS NULL;

--Create Useful Columns
--Convert milliseconds to minutes:

ALTER TABLE spotify ADD COLUMN minutes_played FLOAT;
UPDATE spotify SET minutes_played = ms_played / 60000.0;

SELECT * FROM spotify;

--Extract Date & Hour for Trend Analysis
ALTER TABLE spotify ADD COLUMN play_date DATE;
ALTER TABLE spotify ADD COLUMN play_hour INT;
UPDATE spotify SET play_date = ts::DATE, play_hour = EXTRACT(HOUR FROM ts);

SELECT * FROM spotify;

--Step 4: Exploratory Data Analysis (EDA) in SQL
--1. Total Listening Time
SELECT SUM(minutes_played) AS total_minutes 
FROM spotify;

--2. Top 5 Most Played Songs
SELECT track_name, artist_name, COUNT(*) AS play_count
FROM spotify
GROUP BY track_name, artist_name
ORDER BY play_count DESC
LIMIT 5;

--3.Most Played Artists
SELECT artist_name, Round(SUM(minutes_played)::NUMERIC,2) AS total_play_time
FROM spotify
GROUP BY artist_name
ORDER BY total_play_time DESC
LIMIT 5;

--4. Skipping Behavior
SELECT skipped, COUNT(*) FROM spotify GROUP BY skipped;

--5. Platform Distribution
SELECT platform, COUNT(*) AS total_streams
FROM spotify
GROUP BY platform;

--6. Streaming Trend by Hour
SELECT play_hour, COUNT(*) AS total_streams
FROM spotify
GROUP BY play_hour
ORDER BY total_streams DESC;
 
--INSIGHT 
--1. What Did You Listen To? 🎧
--i) Count of Total Unique Tracks

SELECT COUNT(DISTINCT LOWER(TRIM(track_name))) AS unique_tracks
FROM spotify
WHERE track_name IS NOT NULL;

-- Count of Total Artist
SELECT COUNT(DISTINCT LOWER(TRIM(artist_name))) AS unique_artists
FROM spotify
WHERE artist_name IS NOT NULL;

-- Count of Total Album
SELECT COUNT(DISTINCT LOWER(TRIM(album_name))) AS unique_albums
FROM spotify
WHERE album_name IS NOT NULL;

--ii) Top Song (Most Played Track)
SELECT track_name, artist_name, COUNT(*) AS play_count
FROM spotify
GROUP BY track_name, artist_name
ORDER BY play_count DESC
LIMIT 1;

--iii) Most-Listened Artist
SELECT artist_name, 
       ROUND(SUM(minutes_played)::numeric / 60, 2) AS total_playtime_hours
FROM spotify
GROUP BY artist_name
ORDER BY total_playtime_hours DESC
LIMIT 1;

-- iv) Favorite Album (Most Played Album)
SELECT album_name, artist_name, SUM(minutes_played) AS total_playtime
FROM spotify
GROUP BY album_name, artist_name
ORDER BY total_playtime DESC
LIMIT 1;

--v) Total Listening Hours (Formatted as Days, Hours, Minutes)
WITH total_time AS (
    SELECT SUM(ms_played) AS total_ms FROM spotify
)
SELECT 
    (total_ms / (1000*60*60*24)) || ' days ' || 
    ((total_ms % (1000*60*60*24)) / (1000*60*60)) || ' hours ' || 
    ((total_ms % (1000*60*60)) / (1000*60)) || ' minutes' AS formatted_time
FROM total_time;

-- 2. When Did You Listen? 🕒
--i) Most Active Listening Month (Highest Playtime by Month)
SELECT CONCAT(
        'The most active listening month of the year was ', 
        TO_CHAR(ts, 'Month'), 
        ' with over ', 
        SUM(minutes_played)::INT / 1440, ' days ',  -- Convert minutes to days
        (SUM(minutes_played)::INT % 1440) / 60, ' hours ', -- Remaining hours
        (SUM(minutes_played)::INT % 60), ' minutes played.'
       ) AS listening_summary
FROM spotify
GROUP BY TO_CHAR(ts, 'Month')
ORDER BY SUM(minutes_played) DESC
LIMIT 1;

-- ii) Peak Listening Day (Most Streaming Activity in a Day)
SELECT CONCAT(
        'Peak listening day: ', 
        TO_CHAR(ts, 'Day'), 
        'with over ', 
        ROUND(SUM(minutes_played)::NUMERIC / 60, 0),  -- Convert minutes to hours
        ' hours of listening by far.'
       ) AS peak_listening_day
FROM spotify
GROUP BY TO_CHAR(ts, 'Day')
ORDER BY SUM(minutes_played) DESC
LIMIT 1;

-- iii) Hourly-Weekly Heatmap of Listening Behavior
SELECT
    EXTRACT(DOW FROM ts) AS day_of_week,      -- Day of the week (0=Sunday, 6=Saturday)
    EXTRACT(HOUR FROM ts) AS hour_of_day,     -- Hour of the day (0-23)
    SUM(ms_played) / 60000 AS minutes_played  -- Total minutes listened to
FROM spotify
GROUP BY day_of_week, hour_of_day
ORDER BY day_of_week, hour_of_day;

--iv) Record-Breaking Day Analysis
SELECT
    TO_CHAR(ts, 'YYYY-MM-DD') AS date,   -- Extract the date in YYYY-MM-DD format
    SUM(ms_played) / 60000 AS minutes_played,  -- Total minutes played for that day
    SUM(ms_played) / 3600000 AS hours_played,  -- Total hours played for that day
    SUM(ms_played) / 60000 % 60 AS remaining_minutes,  -- Minutes remaining after calculating full hours
    SUM(ms_played) / 1000 AS seconds_played  -- Total seconds played
FROM spotify
GROUP BY date
ORDER BY minutes_played DESC
LIMIT 1;

-- 3. How Did You Listen? 🔀
--i) Unfinished Play Rate (%)
--Unfinished Play Rate = (Skipped Plays / Total Plays) * 100
SELECT 
    ROUND(
        (COUNT(CASE WHEN reason_end != 'trackdone' THEN 1 END) * 100.0) / COUNT(*), 
        1
    ) AS unfinished_play_rate
FROM spotify;

-- ii) Shuffle Mode Usage (%)
SELECT 
    ROUND(100.0 * SUM(CASE WHEN shuffle THEN 1 ELSE 0 END) / COUNT(*), 2) AS shuffle_usage_rate
FROM spotify;

-- iii) Most Skips at?
SELECT 
    CASE
        WHEN ms_played <= 5000 THEN '0-5 sec'
        WHEN ms_played > 5000 AND ms_played <= 10000 THEN '5-10 sec'
        WHEN ms_played > 10000 AND ms_played <= 20000 THEN '10-20 sec'
        WHEN ms_played > 20000 AND ms_played <= 30000 THEN '20-30 sec'
        WHEN ms_played > 30000 AND ms_played <= 60000 THEN '30-60 sec'
        ELSE 'Over 1 min'
    END AS time_interval,
    COUNT(*) AS skips_in_interval
FROM spotify
WHERE skipped = TRUE
GROUP BY time_interval
ORDER BY skips_in_interval DESC;

-- iv)
-- Reason breakdown for 'start' and 'end' of the track
SELECT 
    reason_start, 
    COUNT(*) AS start_reason_count
FROM spotify
GROUP BY reason_start
ORDER BY start_reason_count DESC;

SELECT 
    reason_end, 
    COUNT(*) AS end_reason_count
FROM spotify
GROUP BY reason_end
ORDER BY end_reason_count DESC;

--4. Where Did You Listen? 📱
--i) Top Device for Streaming (Platform with Most Playtime)
-- Query to find total playtime for each device/platform and calculate percentage
SELECT 
    platform,
    SUM(ms_played) / 60000.0 AS total_playtime_minutes,  -- converting ms_played to minutes
    ROUND(SUM(ms_played) * 100.0 / (SELECT SUM(ms_played) FROM spotify), 2) AS percentage_playtime
FROM spotify
GROUP BY platform
ORDER BY total_playtime_minutes DESC;


