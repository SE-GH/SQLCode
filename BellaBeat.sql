-- Counting distinct user IDs in the dailyActivity dataset
SELECT 
	COUNT(DISTINCT Id) AS DistinctIdCount
FROM dailyActivity;

-- Counting distinct user IDs in the hourlySteps dataset
SELECT 
	COUNT(DISTINCT Id) AS DistinctIdCount
FROM hourlySteps;

-- Counting distinct user IDs in the sleepDay dataset
SELECT 
	COUNT(DISTINCT Id) AS DistinctIdCount
FROM sleepDay;

--There are 33 distinct users for both the dailyactivity and hourlysteps datasets but only 24 for the sleepday. 

-- Counting distinct days of data for each user in the dailyActivity dataset
SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS DistinctDays
FROM dailyActivity
GROUP BY Id
ORDER BY DistinctDays DESC;

-- Counting distinct days of data for each user in the hourlySteps dataset
SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS DistinctDays
FROM hourlySteps
GROUP BY Id
ORDER BY DistinctDays DESC;

-- Counting distinct days of data for each user in the sleepDay dataset
SELECT
    Id,
    COUNT(DISTINCT Sleepday) AS DistinctDays
FROM sleepDay
GROUP BY Id
ORDER BY DistinctDays DESC;

/*There are more records for DailyActivity and hourlysteps than sleep. Most users have at least 31 or 30 days. We also need to find out if for every distinct date of data, 
there are 24 hours of records present for the Hourlysteps. I created a view for this to refer back to when analysing trends and patterns. 
*/

-- Creating a view to refer back to the data 
CREATE VIEW vw_DataCheck AS
SELECT
    Id,
    ActivityDate AS DistinctDate,
    COUNT(*) AS TotalRecords,
    CASE 
        WHEN COUNT(*) = 24 THEN 'Yes' 
        ELSE 'No' 
    END AS Has24Records
FROM hourlySteps
GROUP BY Id, ActivityDate
ORDER BY Has24Records DESC, TotalRecords;

/*-- It seems that most of the distinct dates have 24 hours present. The cases where this is not true is only a small proportion of the data (31 from 934) and within that subset most have at least 10 hours of data. 
We can now start analysing the data to check for trends. As I am interested in how usage varies amongst the different days of the week, I added a column which will show us which weekday corresponds to each date. 
*/

ALTER TABLE hourlySteps
ADD DayOfWeek NVARCHAR(20)

UPDATE hourlySteps
SET DayOfWeek = DATENAME(WEEKDAY, ActivityDate);

ALTER TABLE sleepDay
ADD DayOfWeek NVARCHAR(20)

UPDATE sleepDay
SET DayOfWeek = DATENAME(WEEKDAY, SleepDay);

-- Counting the number of records per day of the week in hourlySteps
SELECT
    DayOfWeek,
    COUNT(*) AS NumberOfRecords
FROM hourlySteps
GROUP BY DayOfWeek
ORDER BY
    CASE DayOfWeek
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

/*The reason we have the highest number of records for Tuesday, Wednesday and Thursday is due to our date range. Our dataset starts on the 12th of April which is a Tuesday and ends on the 12th of May which is a Thursday. 
This explains why we have highest number of records on Tuesday, Wednesday and Thursday.*/

-- Calculating the average number of steps per day of the week in hourlySteps. Users are most active on Saturday and least active on Sunday.
SELECT
    DayOfWeek,
    AVG([StepTotal]) AS AverageSteps
FROM hourlySteps
GROUP BY DayOfWeek
ORDER BY
    CASE 
        WHEN DayOfWeek = 'Monday' THEN 1
        WHEN DayOfWeek = 'Tuesday' THEN 2
        WHEN DayOfWeek = 'Wednesday' THEN 3
        WHEN DayOfWeek = 'Thursday' THEN 4
        WHEN DayOfWeek = 'Friday' THEN 5
        WHEN DayOfWeek = 'Saturday' THEN 6
        WHEN DayOfWeek = 'Sunday' THEN 7
    END;

-- Calculating the average number of steps for each hour of the day in hourlySteps.Users seem most active between the hours of 7AM to 9PM with the most steps between 6PM to 8PM.
SELECT
    [Hour],
    AVG([StepTotal]) AS AverageSteps
FROM hourlySteps
GROUP BY [Hour]
ORDER BY [Hour];

-- Calculating the average minutes of various activity levels in dailyActivity. 
SELECT
    AVG([VeryActiveMinutes]) AS AvgVeryActiveMinutes,
    AVG([FairlyActiveMinutes]) AS AvgFairlyActiveMinutes,
    AVG([LightlyActiveMinutes]) AS AvgLightlyActiveMinutes,
    AVG([SedentaryMinutes]) AS AvgSedentaryMinutes
FROM dailyActivity;

-- I also want to see this broken down by every user and day of week so we can use Tableau to analyse any trends later on. 
SELECT
	Id,
    AVG([VeryActiveMinutes]) AS AvgVeryActiveMinutes,
    AVG([FairlyActiveMinutes]) AS AvgFairlyActiveMinutes,
    AVG([LightlyActiveMinutes]) AS AvgLightlyActiveMinutes,
    AVG([SedentaryMinutes]) AS AvgSedentaryMinutes
FROM dailyActivity
Group by Id

-- Calculating the average minutes of various activity levels for each day of the week in dailyActivity
SELECT
    DayOfWeek,
    AVG([VeryActiveMinutes]) AS AvgVeryActiveMinutes,
    AVG([FairlyActiveMinutes]) AS AvgFairlyActiveMinutes,
    AVG([LightlyActiveMinutes]) AS AvgLightlyActiveMinutes,
    AVG([SedentaryMinutes]) AS AvgSedentaryMinutes
FROM dailyActivity
GROUP BY DayOfWeek;

-- Calculating the average minutes asleep and total time in bed for each user in sleepDay
SELECT
    Id,
    AVG([TotalMinutesAsleep]) AS AverageMinutesAsleep,
    AVG([TotalTimeInBed]) AS AverageTotalTimeInBed,
    AVG([TotalTimeInBed]) - AVG(TotalMinutesAsleep) AS AverageNotAsleepMinutes
FROM sleepDay
GROUP BY Id;

-- Combining dailyActivity and sleepDay data to analyze the relationship between calories, steps, and sleep
SELECT
    da.Id,
    sd.SleepDay,
    sd.TotalMinutesAsleep,
    da.Calories,
    da.TotalSteps
FROM
    dailyActivity AS da
JOIN
    sleepDay AS sd ON da.Id = sd.Id AND da.ActivityDate = sd.SleepDay
ORDER BY da.Id;




