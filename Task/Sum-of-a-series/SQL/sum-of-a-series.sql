create table t1 (n real);
-- this is postgresql specific, fill the table
insert into t1 (select generate_series(1,1000)::real);
with tt as (
  select 1/(n*n) as recip from t1
) select sum(recip) from tt;
