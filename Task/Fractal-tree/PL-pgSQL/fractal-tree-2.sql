WITH RECURSIVE noeuds(azimuth, x0, y0, x, y, len, n) AS (
    VALUES (pi()/2, 0::real, 0::real, 0::real, 10::real, 10::real, 9::int)
  UNION all
    select azimuth+a, x, y, (x+cos(azimuth+a)*len)::real, (y+sin(azimuth+a)*len)::real, (len/2)::real, n-1
    FROM noeuds
    cross join (select (-pi()/7)::real a union select (pi()/7)::real a2) a
    WHERE n > 0
)
, branche as (
    select '('||x0||' '||y0||','||x||' '||y||')' b
    from noeuds
)
select ST_GeomFromEWKT('SRID=4326;MULTILINESTRING('||string_agg(b, ',')||')') tree
from branche
