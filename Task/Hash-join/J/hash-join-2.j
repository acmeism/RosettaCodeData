hash=: ]
dojoin=:3 :0
  c1=. {.{.y
  c2=. (1 {"1 y) -. a:
  c3=. (2 {"1 y) -. a:
  >{c1;c2;<c3
)

JOIN=: ; -.&a: ,/each(hash@{."1 <@dojoin/. ]) (1 1 0&#inv@|."1 table1), 1 0 1#inv"1 table2
