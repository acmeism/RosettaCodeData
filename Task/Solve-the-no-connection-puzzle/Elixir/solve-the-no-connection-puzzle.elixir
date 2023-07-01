# It solved if connected A and B, connected G and H (according to the video).

# require HLPsolver

adjacent = for i <- -2..2, j <- -2..2, not(i in -1..1 and j in -1..1), do: {i,j}
layout = ~S"""
       A - B
      /|\ /|\
     / | X | \
    /  |/ \|  \
   C - D - E - F
    \  |\ /|  /
     \ | X | /
      \|/ \|/
       G - H
"""
board = """
  . 0 0 .
  0 1 0 0
  . 0 0 .
"""
HLPsolver.solve(board, adjacent, false)
|> Enum.sort |> Enum.map(fn {_,cell} -> cell.value end)
|> Enum.zip(~w[A B C D E F G H])
|> Enum.reduce(layout, fn {n,c},acc -> String.replace(acc, c, to_string(n)) end)
|> IO.puts
