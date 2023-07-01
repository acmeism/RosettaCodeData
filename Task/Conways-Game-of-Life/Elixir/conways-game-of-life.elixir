defmodule Conway do
  def game_of_life(name, size, generations, initial_life\\nil) do
    board = seed(size, initial_life)
    print_board(board, name, size, 0)
    reason = generate(name, size, generations, board, 1)
    case reason do
      :all_dead -> "no more life."
      :static   -> "no movement"
      _         -> "specified lifetime ended"
    end
    |> IO.puts
    IO.puts ""
  end

  defp new_board(n) do
    for x <- 1..n, y <- 1..n, into: %{}, do: {{x,y}, 0}
  end

  defp seed(n, points) do
    if points do
      points
    else # randomly seed board
      (for x <- 1..n, y <- 1..n, do: {x,y}) |> Enum.take_random(10)
    end
    |> Enum.reduce(new_board(n), fn pos,acc -> %{acc | pos => 1} end)
  end

  defp generate(_, _, generations, _, gen) when generations < gen, do: :ok
  defp generate(name, size, generations, board, gen) do
    new = evolve(board, size)
    print_board(new, name, size, gen)
    cond do
      barren?(new) -> :all_dead
      board == new -> :static
      true         -> generate(name, size, generations, new, gen+1)
    end
  end

  defp evolve(board, n) do
    for x <- 1..n, y <- 1..n, into: %{}, do: {{x,y}, fate(board, x, y, n)}
  end

  defp fate(board, x, y, n) do
    irange = max(1, x-1) .. min(x+1, n)
    jrange = max(1, y-1) .. min(y+1, n)
    sum = ((for i <- irange, j <- jrange, do: board[{i,j}]) |> Enum.sum) - board[{x,y}]
    cond do
      sum == 3                       -> 1
      sum == 2 and board[{x,y}] == 1 -> 1
      true                           -> 0
    end
  end

  defp barren?(board) do
    Enum.all?(board, fn {_,v} -> v == 0 end)
  end

  defp print_board(board, name, n, generation) do
    IO.puts "#{name}: generation #{generation}"
    Enum.each(1..n, fn y ->
      Enum.map(1..n, fn x -> if board[{x,y}]==1, do: "#", else: "." end)
      |> IO.puts
    end)
  end
end

Conway.game_of_life("blinker", 3, 2, [{2,1},{2,2},{2,3}])
Conway.game_of_life("glider", 4, 4, [{2,1},{3,2},{1,3},{2,3},{3,3}])
Conway.game_of_life("random", 5, 10)
