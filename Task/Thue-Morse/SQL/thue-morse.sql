with recursive a(a) as (select '0' union all select replace(replace(hex(a),'30','01'),'31','10') from a) select * from a;
