fun factorial n = let
  fun loop (i, accum) =
    if i > n then accum
    else loop (i + 1, accum * i)
in
  loop (1, 1)
end
