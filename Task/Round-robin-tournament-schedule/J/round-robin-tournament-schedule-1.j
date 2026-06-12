circ=: {{
  if. 1=2|y do.
    assert. 1<y
    <:(#~ [: */"1 *)"2 circ y+1
  else.
    ids=. i.y
    (-:y) ({.,.|.@}.)"_1] 0,.(}:ids)|."0 1}.ids
  end.
}}
