create table allints (v number);
create table results
(
a number,
b number,
c number,
d number,
e number,
f number,
g number
);

create or replace procedure foursquares(lo number,hi number,uniq boolean,show boolean)
as
    a number;
    b number;
    c number;
    d number;
    e number;
    f number;
    g number;
    out_line varchar2(2000);

    cursor results_cur is
    select
       a,
       b,
       c,
       d,
       e,
       f,
       g
    from
        results
    order by
        a,b,c,d,e,f,g;

    results_rec results_cur%rowtype;

    solutions number;
    uorn varchar2(2000);
begin
    solutions := 0;
    delete from allints;
    delete from results;
    for i in lo..hi loop
        insert into allints values (i);
    end loop;
    commit;

    if uniq = TRUE then
        insert into results
            select
                a.v a,
                b.v b,
                c.v c,
                d.v d,
                e.v e,
                f.v f,
                g.v g
            from
                allints a, allints b, allints c,allints d,
                allints e, allints f, allints g
            where
                a.v not in (b.v,c.v,d.v,e.v,f.v,g.v) and
                b.v not in (c.v,d.v,e.v,f.v,g.v) and
                c.v not in (d.v,e.v,f.v,g.v) and
                d.v not in (e.v,f.v,g.v) and
                e.v not in (f.v,g.v) and
                f.v not in (g.v) and
                a.v = c.v + d.v and
                g.v = d.v + e.v and
                b.v = e.v + f.v - c.v
            order by
                a,b,c,d,e,f,g;
        uorn := ' unique solutions in ';
    else
        insert into results
            select
                a.v a,
                b.v b,
                c.v c,
                d.v d,
                e.v e,
                f.v f,
                g.v g
            from
                allints a, allints b, allints c,allints d,
                allints e, allints f, allints g
            where
                a.v = c.v + d.v and
                g.v = d.v + e.v and
                b.v = e.v + f.v - c.v
            order by
                a,b,c,d,e,f,g;
        uorn := ' non-unique solutions in ';
    end if;
    commit;

    open results_cur;
    loop
        fetch results_cur into results_rec;
        exit when results_cur%notfound;
        a := results_rec.a;
        b := results_rec.b;
        c := results_rec.c;
        d := results_rec.d;
        e := results_rec.e;
        f := results_rec.f;
        g := results_rec.g;

        solutions := solutions + 1;
        if show = TRUE then
            out_line := to_char(a) || ' ';
            out_line := out_line || ' ' || to_char(b) || ' ';
            out_line := out_line || ' ' || to_char(c) || ' ';
            out_line := out_line || ' ' || to_char(d) || ' ';
            out_line := out_line || ' ' || to_char(e) || ' ';
            out_line := out_line || ' ' || to_char(f) ||' ';
            out_line := out_line || ' ' || to_char(g);
        end if;

        dbms_output.put_line(out_line);
    end loop;
    close results_cur;
    out_line := to_char(solutions) || uorn;
    out_line := out_line || to_char(lo) || ' to ' || to_char(hi);
    dbms_output.put_line(out_line);

end;
/
