declare
  proc {Test}
     _ = 1 div 0
  end
in
  try
     {Test}
  catch E then
     {Inspect E}
  end
