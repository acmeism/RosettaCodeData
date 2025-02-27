create or replace table t (x DOUBLE, y DOUBLE);

insert into t select unnest ([1, 2, 3, 1e11]) as x, sqrt(x) as y;
