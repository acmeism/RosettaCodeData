;WITH DATA
     AS (SELECT CAST(ABS(NUMBER) AS NVARCHAR(MAX))      charNum,
                NUMBER,
                LEN(CAST(ABS(NUMBER) AS NVARCHAR(MAX))) LcharNum
         FROM   TABLE1)
SELECT CASE
         WHEN ( LCHARNUM >= 3
                AND LCHARNUM % 2 = 1 ) THEN SUBSTRING(CHARNUM, LCHARNUM / 2, 3)
         ELSE 'Error!'
       END    Output,
       NUMBER Input
FROM   DATA
