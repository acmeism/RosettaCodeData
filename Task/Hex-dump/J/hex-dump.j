hexdump=: {{
  assert. 'literal'-:datatype y
  h=. '',~_2;\_8<@(' '(,,)])\' ',. 0 1}.hfd 256+a.i.y
  a=. '',~_16('  |','|',~])\(y e.32}.127{.a.)}'.',:y
  i=. 0 1}.hfd(2^32)+16*i.#h
  i,.h,.a
}}

bindump=: {{
  assert. 'literal'-:datatype y
  b=. '',~_6(' ',,)\' ',.,/"2":"0(8#2)#:256+a.i.y
  a=. '',~_6('  |','|',~])\(y e.32}.127{.a.)}'.',:y
  i=. 0 1}.hfd(2^32)+6*i.#b
  i,.b,.a
}}
