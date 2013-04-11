declare
  Arr = {Array.new 0 10 {OS.rand}} %% WRONG: contains ten times the same number
in
  %% CORRECT: fill it with ten (probably) different numbers
  for I in {Array.low Arr}..{Array.high Arr} do
     Arr.I := {OS.rand}
  end
