def mapreduce(mapper; reducer; zero):
  if length == 0 then zero
  else map(mapper) | reducer
  end;
