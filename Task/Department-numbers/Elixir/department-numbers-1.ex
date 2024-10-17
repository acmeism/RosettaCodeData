IO.puts("P - F - S")
for p <- [2,4,6],
  f <- 1..7,
  s <- 1..7,
  p != f and p != s and f != s and p + f + s == 12 do
    "#{p} - #{f} - #{s}"
  end
  |> Enum.each(&IO.puts/1)
