create temporary table nos (v int);
insert into nos values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
create temporary table evens (v int);
insert into evens select v from nos where v%2=0;
select * from evens order by v; /*2,4,6,8,10*/
drop table nos;
drop table evens;
