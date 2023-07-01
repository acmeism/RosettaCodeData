WITH RECURSIVE cte AS (
    SELECT DATE('2008-12-25', '+'||(12*0)||' months') as dt, 1 AS level
    UNION  ALL
    SELECT DATE('2008-12-25', '+'||(12*level)||' months') as dt, c.level + 1
    FROM   cte c
    WHERE c.level <= 2121 - 2008 + 1
    )
 SELECT strftime('%Y', dt)
 FROM   cte
 where  strftime('%w', dt) = '0';
