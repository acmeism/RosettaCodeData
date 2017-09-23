# skip m states, and return the next state
def skip(m; next):
  if m <= 0 then . else next | skip(m-1; next) end;

# emit m states including the initial state
def emit(m; next):
  if m <= 0 then empty else ., (next | emit(m-1; next)) end;
