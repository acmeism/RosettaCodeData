fun{FibI N}
  Temp = {NewCell 0}
  A = {NewCell 0}
  B = {NewCell 1}
in
  for I in 1..N do
    Temp := @A + @B
    A := @B
    B := @Temp
  end
  @A
end
