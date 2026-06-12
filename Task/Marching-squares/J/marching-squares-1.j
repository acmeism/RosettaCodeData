step1=: {{2 2 #.@(0 1 3 2&{)@,;._3 ,&0^:2@|:@|.^:4 y}}
step2=: {{(($y)#:i.$y) {{<x step2a y{::LUT}}"1 0 y}}
step2a=: {{ if. #y do. x+"1 y else. y end. }}
LUT=: <@".;._2 {{)n
  EMPTY      NB. 0
  0 0,:1 1   NB. 1
  0 1,:1 0   NB. 2
  0 0,:0 1   NB. 3
  0 0,:1 1   NB. 4
  0 1,:1 0   NB. 5
  0 0,:1 0   NB. 6
  EMPTY      NB. 7 0 1,:1 0
  1 0,:0 1   NB. 8
  1 1,:0 1   NB. 9
  0 0,:1 1   NB. 10
  EMPTY      NB. 11 0 0,:1 1
  1 0,:1 1   NB. 12
  EMPTY      NB. 13 0 1,:1 0
  EMPTY      NB. 14 0 0,:1 1
  EMPTY      NB. 15
}}

unwind=: {{
  near=. 6 7 8 5 2 3 1 0 {,(+/~ *&({:$y))i:1
  r=., c=. EMPTY
  TODO=. I.(<EMPTY)~:Y=.,y
  j=. _
  while.#TODO=. TODO-.j do.
    adj=. (j+near) ([-.-.) TODO
    if. #adj do.
      j=. {.adj
    else.
      if. #c do. c=.EMPTY [r=. r,<~.c end.
      j=. {.TODO
    end.
    c=. c, j{::Y
  end.
  r,<~.c
}}
