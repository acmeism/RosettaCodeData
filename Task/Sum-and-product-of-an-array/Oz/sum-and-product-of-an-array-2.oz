declare
  Arr = {Array.new 1 3 0}
  Sum = {NewCell 0}
in
  Arr.1 := 1
  Arr.2 := 2
  Arr.3 := 3

  for I in {Array.low Arr}..{Array.high Arr} do
     Sum := @Sum + Arr.I
  end
  {Show @Sum}
