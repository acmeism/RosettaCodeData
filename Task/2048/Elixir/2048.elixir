defmodule Game2048 do
  @size 4
  @range 0..@size-1

  def play(goal \\ 2048), do: setup() |> play(goal)

  defp play(board, goal) do
    show(board)
    cond do
      goal in Map.values(board) ->
          IO.puts "You win!"
          exit(:normal)
      0 in Map.values(board) or combinable?(board) ->
          moved = move(board, keyin())
          if moved == board, do: play(board, goal), else: add_tile(moved) |> play(goal)
      true ->
          IO.puts "Game Over!"
          exit(:normal)
    end
  end

  defp setup do
    (for i <- @range, j <- @range, into: %{}, do: {{i,j},0})
    |> add_tile
    |> add_tile
  end

  defp add_tile(board) do
    position = blank_space(board) |> Enum.random
    tile = if :rand.uniform(10)==1, do: 4, else: 2
    %{board | position => tile}
  end

  defp blank_space(board) do
    for {key, 0} <- board, do: key
  end

  defp keyin do
    key = IO.gets("key in wasd or q: ")
    case String.first(key) do
      "w" -> :up
      "a" -> :left
      "s" -> :down
      "d" -> :right
      "q" -> exit(:normal)
      _   -> keyin()
    end
  end

  defp move(board, :up) do
    Enum.reduce(@range, board, fn j,acc ->
      Enum.map(@range, fn i -> acc[{i,j}] end)
      |> move_and_combine
      |> Enum.with_index
      |> Enum.reduce(acc, fn {v,i},map -> Map.put(map, {i,j}, v) end)
    end)
  end
  defp move(board, :down) do
    Enum.reduce(@range, board, fn j,acc ->
      Enum.map(@size-1..0, fn i -> acc[{i,j}] end)
      |> move_and_combine
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.reduce(acc, fn {v,i},map -> Map.put(map, {i,j}, v) end)
    end)
  end
  defp move(board, :left) do
    Enum.reduce(@range, board, fn i,acc ->
      Enum.map(@range, fn j -> acc[{i,j}] end)
      |> move_and_combine
      |> Enum.with_index
      |> Enum.reduce(acc, fn {v,j},map -> Map.put(map, {i,j}, v) end)
    end)
  end
  defp move(board, :right) do
    Enum.reduce(@range, board, fn i,acc ->
      Enum.map(@size-1..0, fn j -> acc[{i,j}] end)
      |> move_and_combine
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.reduce(acc, fn {v,j},map -> Map.put(map, {i,j}, v) end)
    end)
  end

  defp move_and_combine(tiles) do
    (Enum.filter(tiles, &(&1>0)) ++ [0,0,0,0])
    |> Enum.take(@size)
    |> case do
         [a,a,b,b] -> [a*2, b*2, 0, 0]
         [a,a,b,c] -> [a*2, b, c, 0]
         [a,b,b,c] -> [a, b*2, c, 0]
         [a,b,c,c] -> [a, b, c*2, 0]
         x         -> x
       end
  end

  defp combinable?(board) do
    Enum.any?(for i <- @range, j <- 0..@size-2, do: board[{i,j}]==board[{i,j+1}]) or
    Enum.any?(for j <- @range, i <- 0..@size-2, do: board[{i,j}]==board[{i+1,j}])
  end

  @frame   String.duplicate("+----", @size) <> "+"
  @format (String.duplicate("|~4w", @size) <> "|") |> to_charlist   # before 1.3 to_char_list

  defp show(board) do
    Enum.each(@range, fn i ->
      IO.puts @frame
      row = for j <- @range, do: board[{i,j}]
      IO.puts (:io_lib.fwrite @format, row) |> to_string |> String.replace(" 0|", "  |")
    end)
    IO.puts @frame
  end
end

Game2048.play 512
