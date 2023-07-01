drop table if exists my_temp_tree_table;

do $$
declare
  _length numeric := 1;
  -- a little random
  _random_length_reduction_max numeric := 0.6;
  _fork_angle numeric := pi()/12;
  -- a little random
  _random_angle numeric := pi()/12;
  _depth numeric := 9 ;

begin
    create temporary table my_temp_tree_table as
        WITH RECURSIVE branch(azimuth, x1, y1, x2, y2, len, n) AS (
            VALUES (pi()/2, 0.0, 0.0, 0.0, _length, _length, _depth)
          UNION all
            select azimuth+a,
                x2, y2,
                round((x2+cos(azimuth+a)*len)::numeric, 2), round((y2+sin(azimuth+a)*len)::numeric, 2),
                (len*(_random_length_reduction_max+(random()*(1-_random_length_reduction_max))))::numeric,
                n-1
            FROM branch
            cross join (
                select ((-_fork_angle)+(_random_angle)*(random()-0.5)) a
                union
                select ((_fork_angle)+(_random_angle)*(random()-0.5)) a2
            ) a
            WHERE n > 0
        )
        select x1, y1, x2, y2, 'LINESTRING('||x1||' '||y1||','||x2||' '||y2||')' as wkt from branch
        ;
end $$
;

-- coordinates and WKT
select * from my_temp_tree_table;

-- binary version (postgis) of each branch
select ST_GeomFromEWKT('SRID=4326;'||wkt) geom from my_temp_tree_table;

-- a unique geometry
select st_union(ST_GeomFromEWKT('SRID=4326;'||wkt)) geom from my_temp_tree_table;
