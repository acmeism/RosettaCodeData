-- Juila Set
-- SQL Server 2017 and above
SET NOCOUNT ON
GO

-- Plot area 800 X 600
DECLARE @width INT = 800
DECLARE @height INT = 600

DECLARE @r_min DECIMAL (10, 8) = -1.5;
DECLARE @r_max DECIMAL (10, 8) = 1.5;
DECLARE @i_min DECIMAL (10, 8) = -1;
DECLARE @i_max DECIMAL (10, 8) = 1;

DECLARE @zoom INT = 1,
		@moveX INT = 0,
		@moveY INT = 0;

DECLARE @iter INT = 255; -- Iteration

DROP TABLE IF EXISTS dbo.Numbers
DROP TABLE IF EXISTS dbo.julia_set;

CREATE TABLE dbo.Numbers (n INT);

-- Generate a number table of 1000 rows
;WITH N1(n) AS
(
    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
), -- 10
N2(n) AS (SELECT 1 FROM N1 CROSS JOIN N1 AS b), -- 10*10
N3(n) AS (SELECT 1 FROM N1 CROSS JOIN N2) -- 10*100
INSERT INTO dbo.Numbers (n)
SELECT n = ROW_NUMBER() OVER (ORDER BY n)
FROM N3 ORDER BY n;
/*
-- If the version is SQL Server 2022 and above
INSERT INTO dbo.Numbers (n)
SELECT value FROM GENERATE_SERIES(0, 1000);
*/

CREATE TABLE dbo.julia_set
(
	a INT,
	b INT,
	c_re DECIMAL (10, 8),
	c_im DECIMAL (10, 8),
	z_re DECIMAL (10, 8) DEFAULT 0,
	z_im DECIMAL (10, 8) DEFAULT 0,
	znew_re DECIMAL (10, 8) DEFAULT 0,
	znew_im DECIMAL (10, 8) DEFAULT 0,
	steps INT DEFAULT 0,
	active BIT DEFAULT 1,
)

-- Store all the z_re, z_im with constant c_re, c_im corresponding to each point in the plot area
-- Generate 480,000 rows (800 X 600)
INSERT INTO dbo.julia_set (a, b, c_re, c_im, z_re, z_im, steps)
SELECT   a.n as a, b.n as b
		,-0.7 AS c_re
		,0.27015 AS c_im
		,@r_max * (a.n - @width / 2) / (0.5 * @zoom * @width) + @moveX AS z_re
		,@i_max * (b.n - @height / 2) / (0.5 * @zoom * @height) + @moveY AS z_im
		,@iter as steps
FROM
		(
		SELECT n - 1 as n FROM dbo.Numbers WHERE n <= @width
		) as a
CROSS JOIN
		(
		SELECT n - 1 as n FROM dbo.Numbers WHERE n <= @height
		) as b;

-- Iteration
WHILE (@iter > 1)
	BEGIN

		UPDATE dbo.julia_set
		SET
			znew_re = POWER(z_re,2)-POWER(z_im,2)+c_re,
			znew_im = 2*z_re*z_im+c_im,
			steps = steps-1
		WHERE active=1;

		UPDATE dbo.julia_set
		SET
			z_re=znew_re,
			z_im=znew_im,
			active= CASE
						WHEN POWER(znew_re,2)+POWER(znew_im,2)>4 THEN 0
						ELSE 1
					END
		WHERE active=1;

		SET @iter = @iter - 1;
	END

-- Generating PPM File
-- Save the below query results to a file with extension .ppm
-- NOTE : All the unwanted info like 'rows affected', 'completed time' etc. needs to be
-- removed from the file. Most of the image editing softwares and online viewers can display the .ppm file
SELECT 'P3' UNION ALL
SELECT CAST(@width AS VARCHAR(5)) + ' ' + CAST(@height AS VARCHAR(5)) UNION ALL
SELECT '255' UNION ALL
SELECT
	STRING_AGG(CAST(CASE WHEN active = 1 THEN 0 ELSE 55 + steps % 200 END AS VARCHAR(MAX)) + ' ' -- R
	+ CAST(CASE WHEN active = 1 THEN 0 ELSE 55+POWER(steps,3) %  200 END AS VARCHAR(MAX)) + ' '  -- G
	+ CAST(CASE WHEN active = 1 THEN 0 ELSE 55+ POWER(steps,2) % 200 END AS VARCHAR(MAX))		-- B
	, ' ') WITHIN GROUP (ORDER BY a, b)
FROM dbo.julia_set
GROUP BY a, b
