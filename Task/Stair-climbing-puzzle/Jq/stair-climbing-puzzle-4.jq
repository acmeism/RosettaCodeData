def step_up:
  if step then tick
  else tick | step_up | step_up
  end;
