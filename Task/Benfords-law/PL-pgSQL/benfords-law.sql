WITH recursive
constant(val) AS
(
select 1000.
)
,
fib(a,b) AS
(
SELECT CAST(0 AS numeric), CAST(1 AS numeric)
UNION ALL
SELECT b,a+b
FROM fib
)
,
benford(first_digit, probability_real, probability_theoretical) AS
(
SELECT *,
	CAST(log(1. + 1./CAST(first_digit AS INT)) AS NUMERIC(5,4)) probability_theoretical
FROM (
	SELECT  first_digit, CAST(COUNT(1)/(select val from constant) AS NUMERIC(5,4)) probability_real FROM
	(
		SELECT SUBSTRING(CAST(a AS VARCHAR(100)),1,1) first_digit
		FROM fib
		WHERE SUBSTRING(CAST(a AS VARCHAR(100)),1,1) <> '0'
		LIMIT (select val from constant)
	) t
	GROUP BY first_digit
) f
ORDER BY first_digit ASC
)
select *
from benford cross join
     (select cast(corr(probability_theoretical,probability_real) as numeric(5,4)) correlation
      from benford) c
