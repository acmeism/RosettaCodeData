/*These statements work in PostgreSQL (tested in 9.3)*/

SELECT generate_series || ' bottles of beer on the wall' || chr(10) ||
generate_series || ' bottles of beer' || chr(10) ||
'Take one down, pass it around' || chr(10) ||
coalesce(lead(generate_series) OVER (ORDER BY generate_series DESC),0) || ' bottles of beer on the wall'
FROM generate_series(1,100)
ORDER BY generate_series DESC;

/*The next statement takes also into account the grammaticalt support for "1 bottle of beer".*/

SELECT generate_series || ' bottle' || CASE WHEN generate_series>1 THEN 's' ELSE '' END || ' of beer on the wall' || chr(10) ||
generate_series || ' bottle' || CASE WHEN generate_series>1 THEN 's' ELSE '' END || ' of beer' || chr(10) ||
'Take one down, pass it around' || chr(10) ||
coalesce(lead(generate_series) OVER (ORDER BY generate_series DESC),0) || ' bottle' || CASE WHEN coalesce(lead(generate_series) OVER (ORDER BY generate_series DESC),0) <>1 THEN 's' ELSE '' END || ' of beer on the wall'
FROM generate_series(1,100)
ORDER BY generate_series DESC;

/*The next statement uses recursive query.*/

WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT n || ' bottle' || CASE WHEN n>1 THEN 's' ELSE '' END || ' of beer on the wall' || chr(10) ||
n || ' bottle' || CASE WHEN n>1 THEN 's' ELSE '' END || ' of beer' || chr(10) ||
'Take one down, pass it around' || chr(10) ||
coalesce(lead(n) OVER (ORDER BY n DESC),0) || ' bottle' ||
CASE WHEN coalesce(lead(n) OVER (ORDER BY n DESC),0) <>1 THEN 's' ELSE '' END || ' of beer on the wall'
FROM t
ORDER BY n DESC;
