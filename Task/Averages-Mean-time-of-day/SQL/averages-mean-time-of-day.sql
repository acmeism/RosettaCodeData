--Setup table for testing
CREATE TABLE time_table(times time);
INSERT INTO time_table values ('23:00:17'::time),('23:40:20'::time),('00:12:45'::time),('00:17:19'::time)

--Compute mean time
SELECT to_timestamp((degrees(atan2(AVG(sin),AVG(cos))))* (24*60*60)/360)::time
FROM
	(SELECT
	cos(radians(t*360/(24*60*60))),sin(radians(t*360/(24*60*60)))
	FROM
		(SELECT EXTRACT(epoch from times) t
		FROM time_table) T1
	)T2
