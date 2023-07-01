kosaraju=: {{
  coerase([cocurrent)cocreate''
  visit=: {{
    if.y{unvisited do.
      unvisited=: 0 y} unvisited
      visit y{::out
      L=: y,L
    end.
  }}"0
  assign=: {{
    if._1=y{assigned do.
      assigned=: x y} assigned
      x&assign y{::in
    end.
  }}"0
  out=: y
  in=: <@I.|:y e.S:0~i.#y
  unvisited=: 1#~#y
  assigned=: _1#~#y
  L=: i.0
  visit"0 i.#y
  assign~L
  assigned
}}
