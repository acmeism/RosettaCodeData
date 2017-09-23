def step:
  random as $r
  | if . >= ($r|length) then true else ($r[.] == 1) end ;
