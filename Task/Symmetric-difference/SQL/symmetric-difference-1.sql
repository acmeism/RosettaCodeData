create or replace function arrxor(anyarray,anyarray) returns anyarray as $$
select ARRAY(
        (
        select r.elements
        from    (
                (select 1,unnest($1))
                union all
                (select 2,unnest($2))
                ) as r (arr, elements)
        group by 1
        having min(arr) = max(arr)
        )
)
$$ language sql strict immutable;
