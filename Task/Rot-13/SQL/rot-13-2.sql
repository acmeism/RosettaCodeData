with cte(num) as
(
 select 1
 union all
 select num+1
 from cte
)
select cast((
select char(ascii(chr) +
		case
			when    ascii(chr) between ascii('a') and ascii('m') or
				ascii(chr) between ascii('A') and ascii('M') then 13
			when    ascii(chr) between ascii('n') and ascii('z') or
				ascii(chr) between ascii('N') and ascii('Z') then -13
			else    0
		end)
from
(
select top(1000) num,
		 -- your string to be converted to ROT13
                 substring('The Quick Brown Fox Jumps Over The Lazy Dog',num,1) chr
from cte
) tmp
For XML PATH ('')) as xml).value('.', 'VARCHAR(max)') rot13
option (maxrecursion 0)
