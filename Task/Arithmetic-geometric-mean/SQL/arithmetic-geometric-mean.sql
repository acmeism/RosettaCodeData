with
  rec (rn, a, g, diff) as (
    select  1, 1, 1/sqrt(2), 1 - 1/sqrt(2)
      from  dual
    union all
    select  rn + 1, (a + g)/2, sqrt(a * g), (a + g)/2 - sqrt(a * g)
      from  rec
      where diff > 1e-38
  )
select *
from   rec
where  diff <= 1e-38
;
