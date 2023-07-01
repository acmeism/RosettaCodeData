-- variable table
drop table if exists var;
create temp table var (	value varchar(1000) );
insert into var(value) select 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW';

-- select
with recursive
ints(num) as
(
	select 1
	union all
	select num+1
	from ints
	where num+1 <= length((select value from var))
)
,
chars(num,chr,nextChr,isGroupEnd) as
(
	select tmp.*, case when tmp.nextChr <> tmp.chr then 1 else 0 end groupEnds
	from (
	select num,
		   substring((select value from var), num, 1) chr,
		   (select substring((select value from var), num+1, 1)) nextChr
	from ints
	) tmp
)
select (select value from var) plain_text, (
	select string_agg(concat(cast(maxNoWithinGroup as varchar(10)) , chr), '' order by num)
	from (
		select *, max(noWithinGroup) over (partition by chr, groupNo) maxNoWithinGroup
		from (
			select	num,
					chr,
					groupNo,
					row_number() over( partition by chr, groupNo order by num) noWithinGroup
			from (
			select *, (select count(*)
					   from chars chars2
					   where chars2.isGroupEnd = 1 and
					   chars2.chr = chars.chr and
					   chars2.num < chars.num) groupNo
			from chars
			) tmp
		) sub
	) final
	where noWithinGroup = 1
	) Rle_Compressed
