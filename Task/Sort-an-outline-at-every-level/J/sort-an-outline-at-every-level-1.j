parse2=: {{
  ((=<./)y (1 i.~ -.@e.)S:0 m) m {{
    ({.y),<m parse2^:(*@#)}.y
  }};.1 y
}}

parseout=: {{
  ws=. ' ',TAB
  lines=: <;.2 y
  indents=: lines (1 i.~ -.@e.)S:0 ws
  unit=: +./indents
  if. -. (-: i.@#)~.indents%unit do.
    echo 'inconsistent indent widths'
  end.
  if. 1~:#~.;indents unit{{<(1,:m) <;._3 x{.;y }}"0 lines do.
    echo 'inconsistent use of whitespace characters'
  end.
  ws parse2 lines
}} :.unparse

sortout=: {{ if. L.y do. u~ ({."1 y),.u sortout each}."1 y else. u~y end. }}

unparse=: {{ ;<S:0 y }}
