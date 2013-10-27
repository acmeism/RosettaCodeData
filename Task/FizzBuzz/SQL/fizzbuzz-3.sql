WITH nums (n, fizzbuzz ) AS (
	SELECT 1, CONVERT(nvarchar, 1) UNION ALL
	SELECT
		(n + 1) as n1,
		CASE
			WHEN (n + 1) % 15 = 0 THEN 'FizzBuzz'
			WHEN (n + 1) % 3  = 0 THEN 'Fizz'
			WHEN (n + 1) % 5  = 0 THEN 'Buzz'
			ELSE CONVERT(nvarchar, (n + 1))
		END
	FROM nums WHERE n < 100
)
SELECT n, fizzbuzz FROM nums
ORDER BY n ASC
OPTION ( MAXRECURSION 100 )
