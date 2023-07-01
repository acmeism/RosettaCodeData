declare
  V = 42
in
  {Wait V}  %% explicitly wait for V to become determined

  if {IsDet V} then  %% check whether V is determined; not recommended
     {Show determined}
  elseif {IsFree V} then  %% check whether V is free; not recommended
     {Show free}
  end
