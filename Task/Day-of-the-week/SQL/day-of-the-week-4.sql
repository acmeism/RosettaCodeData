 WITH RECURSIVE cte AS (
    SELECT  date '2008-12-25' + interval '12 month' * 0 as dt, 1 AS level
    UNION  ALL
    SELECT date '2008-12-25' + interval '12 month' * level as dt, c.level + 1
    FROM   cte c
    WHERE c.level <= 2121 - 2008 + 1
    )
 SELECT dt
 FROM   cte
 where  to_char(dt, 'Dy') = 'Sun';
