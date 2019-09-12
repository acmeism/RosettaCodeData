drop table tbl;
create table tbl
(
        u       number,
        v       number
);

insert into tbl ( u, v ) values ( 20, 50 );
insert into tbl ( u, v ) values ( 21, 50 );
insert into tbl ( u, v ) values ( 21, 51 );
insert into tbl ( u, v ) values ( 22, 50 );
insert into tbl ( u, v ) values ( 22, 55 );

commit;

with
        function gcd ( ui in number, vi in number )
        return number
        is
                u number := ui;
                v number := vi;
                t number;
        begin
                while v > 0
                loop
                        t := u;
                        u := v;
                        v:= mod(t, v );
                end loop;
                return abs(u);
        end gcd;
        select u, v, gcd ( u, v )
        from tbl
/
