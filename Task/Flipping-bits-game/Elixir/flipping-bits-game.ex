defmodule Flip_game do
  @az  Enum.map(?a..?z, &List.to_string([&1]))
  @in2i Enum.concat(Enum.map(1..26, fn i -> {to_string(i), i} end),
                    Enum.with_index(@az) |> Enum.map(fn {c,i} -> {c,-i-1} end))
        |> Enum.into(Map.new)

  def play(n) when n>2 do
    target = generate_target(n)
    display(n, "Target: ", target)
    board = starting_config(n, target)
    play(n, target, board, 1)
  end

  def play(n, target, board, moves) do
    display(n, "Board: ", board)
    ans = IO.gets("row/column to flip: ") |> String.strip |> String.downcase
    new_board = case @in2i[ans] do
                  i when i in 1..n   -> flip_row(n, board, i)
                  i when i in -1..-n -> flip_column(n, board, -i)
                  _ -> IO.puts "invalid input: #{ans}"
                       board
                end
    if target == new_board do
      display(n, "Board: ", new_board)
      IO.puts "You solved the game in #{moves} moves"
    else
      IO.puts ""
      play(n, target, new_board, moves+1)
    end
  end

  defp generate_target(n) do
    for i <- 1..n, j <- 1..n, into: Map.new, do: {{i, j}, :rand.uniform(2)-1}
  end

  defp starting_config(n, target) do
    Enum.concat(1..n, -1..-n)
    |> Enum.take_random(n)
    |> Enum.reduce(target, fn x,acc ->
         if x>0, do: flip_row(n, acc, x),
               else: flip_column(n, acc, -x)
       end)
  end

  defp flip_row(n, board, row) do
    Enum.reduce(1..n, board, fn col,acc ->
      Map.update!(acc, {row,col}, fn bit -> 1 - bit end)
    end)
  end

  defp flip_column(n, board, col) do
    Enum.reduce(1..n, board, fn row,acc ->
      Map.update!(acc, {row,col}, fn bit -> 1 - bit end)
    end)
  end

  defp display(n, title, board) do
    IO.puts title
    IO.puts "   #{Enum.join(Enum.take(@az,n), " ")}"
    Enum.each(1..n, fn row ->
      :io.fwrite "~2w ", [row]
      IO.puts Enum.map_join(1..n, " ", fn col -> board[{row, col}] end)
    end)
  end
end

Flip_game.play(3)
