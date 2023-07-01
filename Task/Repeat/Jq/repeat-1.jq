def unoptimized_repeat(f; n):
  if n <= 0 then empty
  else f, repeat(f; n-1)
  end;
