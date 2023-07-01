kosarajud=: {{
  coerase([cocurrent)cocreate''
  visit=: {{
    if.y{unvisited do.
      unvisited=: 0 y} unvisited
      visit y{::out
      L=: y,L
    end.
  }}"0
  assign=: {{
    if.-.y e.;assigned do.
      assigned=: (y,L:0~x{assigned) x} assigned
      x&assign y{::in
    end.
  }}"0
  out=: y
  in=: <@I.|:y e.S:0~i.#y
  unvisited=: 1#~#y
  assigned=: a:#~#y
  L=: i.0
  visit"0 i.#y
  assign~L
  assigned
}}

   kosarajud 1;2;0;1 2 4;3 5;2 6;5;4 6 7
┌─────┬┬┬───┬┬───┬┬─┐
│0 2 1│││3 4││5 6││7│
└─────┴┴┴───┴┴───┴┴─┘
