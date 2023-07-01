fun{FibR N}
  if N < 2 then N
  else {FibR N-1} + {FibR N-2}
  end
end
