multisplit=: {{
  'begin sep'=. |:bs=. _,~/:~;(,.&.>i.@#) y I.@E.L:0 x NB.
  len=. #@>y NB.
  r=. i.3 0
  j=. k=. 0
  while.j<#x do.
    while. j>k{begin do. k=.k+1 end.
    'b s'=. k{bs NB. character index where separator appears, separator index
    if. _=b do. r,.(j}.x);'';'' return. end.
    txt=. (j + i. b-j){x
    j=. b+s{len
    r=.r,.txt;(s{::y);b
  end.
}}
