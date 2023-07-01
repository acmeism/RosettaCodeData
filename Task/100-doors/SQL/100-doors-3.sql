with numbers as (
    select rownum as n from dual connect by level <= 100
),
passes as (
    select doors.n door, count(passes.n) pass_number
    from numbers doors
    cross join numbers passes
    where MOD(doors.n, passes.n) = 0  -- modulo
    group by doors.n
)
select door from passes
where MOD(pass_number, 2) = 1
order by door
