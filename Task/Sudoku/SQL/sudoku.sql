with
  symbols (d) as (select to_char(level) from dual connect by level <=  9)
, board   (i) as (select level          from dual connect by level <= 81)
, neighbors (i, j) as (
    select b1.i, b2.i
    from   board b1 inner join board b2
      on   b1.i != b2.i
           and (
                    mod(b1.i - b2.i, 9) = 0
                 or ceil(b1.i /  9) = ceil(b2.i /  9)
                 or ceil(b1.i / 27) = ceil(b2.i / 27) and trunc(mod(b1.i - 1, 9) / 3) = trunc(mod(b2.i - 1, 9) / 3)
               )
  )
, r (str, pos) as (
    select  :game, instr(:game, ' ')
      from  dual
    union all
    select  substr(r.str, 1, r.pos - 1) || s.d || substr(r.str, r.pos + 1), instr(r.str, ' ', r.pos + 1)
      from  r inner join symbols s
        on  r.pos > 0 and not exists (
                                       select *
                                       from   neighbors n
                                       where  r.pos = n.i and s.d = substr(r.str, n.j, 1)
                                     )
  )
select str
from   r
where  pos = 0
;
