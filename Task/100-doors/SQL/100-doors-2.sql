with numbers as (
    select generate_series(1, 100) as n
),
passes as (
    select passes.n pass, doors.n door
    from numbers doors
    cross join numbers passes
    where doors.n % passes.n = 0  -- modulo
),
counting as (
    select door, count(pass) pass_number
    from passes
    group by door
)
select door from counting
where pass_number % 2 = 1
order by door
