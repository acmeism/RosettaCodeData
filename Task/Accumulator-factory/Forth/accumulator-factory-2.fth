: faccumulator ( r "name" -- )
  create falign f,
does> ( r1 -- r2 )
  faligned dup f@ f+ fdup f! ;

1 s>f faccumulator x
5 s>f x fdrop
3 s>f faccumulator y \ unused
2.3e x f.
