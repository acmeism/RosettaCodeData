create table "numbers" ("datapoint" integer);

insert into "numbers" select rownum from tab;

select sum("datapoint")/count(*)  from "numbers";
