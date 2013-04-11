--Create the original array (table #nos) with numbers from 1 to 10
create table #nos (v int)
declare @n int set @n=1
while @n<=10 begin insert into #nos values (@n) set @n=@n+1 end

--Select the subset that are even into the new array (table #evens)
select v into #evens from #nos where v % 2 = 0

-- Show #evens
select * from #evens

-- Clean up so you can edit and repeat:
drop table #nos
drop table #evens
