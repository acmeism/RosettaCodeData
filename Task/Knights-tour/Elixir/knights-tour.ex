defmodule Board do
  import Integer, only: [is_odd: 1]

  defmodule Cell do
    defstruct [:value, :adj]
  end

  @adjacent  [[-1,-2],[-2,-1],[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2]]

  defp initialize(rows, cols) do
    board = for i <- 1..rows, j <- 1..cols, into: %{}, do: {{i,j}, true}
    for i <- 1..rows, j <- 1..cols, into: %{} do
      adj = for [di,dj] <- @adjacent, board[{i+di, j+dj}], do: {i+di, j+dj}
      {{i,j}, %Cell{value: 0, adj: adj}}
    end
  end

  defp solve(board, ij, num, goal) do
    board = Map.update!(board, ij, fn cell -> %{cell | value: num} end)
    if num == goal do
      throw({:ok, board})
    else
      wdof(board, ij)
      |> Enum.each(fn k -> solve(board, k, num+1, goal) end)
    end
  end

  defp wdof(board, ij) do               # Warnsdorf's rule
    board[ij].adj
    |> Enum.filter(fn k -> board[k].value == 0 end)
    |> Enum.sort_by(fn k ->
         Enum.count(board[k].adj, fn x -> board[x].value == 0 end)
       end)
  end

  defp to_string(board, rows, cols) do
    width = to_string(rows * cols) |> String.length
    format = String.duplicate("~#{width}w ", cols)
    Enum.map_join(1..rows, "\n", fn i ->
      :io_lib.fwrite format, (for j <- 1..cols, do: board[{i,j}].value)
    end)
  end

  def knight_tour(rows, cols, sx, sy) do
    IO.puts "\nBoard (#{rows} x #{cols}), Start: [#{sx}, #{sy}]"
    if is_odd(rows*cols) and is_odd(sx+sy) do
      IO.puts "No solution"
    else
      try do
        initialize(rows, cols)
        |> solve({sx,sy}, 1, rows*cols)
        IO.puts "No solution"
      catch
        {:ok, board} -> IO.puts to_string(board, rows, cols)
      end
    end
  end
end

Board.knight_tour(8,8,4,2)
Board.knight_tour(5,5,3,3)
Board.knight_tour(4,9,1,1)
Board.knight_tour(5,5,1,2)
Board.knight_tour(12,12,2,2)
