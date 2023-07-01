-- setup
create table pairs (name varchar(16), value varchar(16));
insert into pairs values ('Fluffy', 'cat');
insert into pairs values ('Fido', 'dog');
insert into pairs values ('Francis', 'fish');
-- order them by name
select * from pairs order by name;
