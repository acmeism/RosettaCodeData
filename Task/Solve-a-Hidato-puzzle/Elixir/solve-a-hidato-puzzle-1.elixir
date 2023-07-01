# Solve a Hidato Like Puzzle with Warnsdorff like logic applied
#
defmodule HLPsolver do
  defmodule Cell do
    defstruct value: -1, used: false, adj: []
  end

  def solve(str, adjacent, print_out\\true) do
    board = setup(str)
    if print_out, do: print(board, "Problem:")
    {start, _} = Enum.find(board, fn {_,cell} -> cell.value==1 end)
    board = set_adj(board, adjacent)
    zbl = for %Cell{value: n} <- Map.values(board), into: %{}, do: {n, true}
    try do
      solve(board, start, 1, zbl, map_size(board))
      IO.puts "No solution"
    catch
      {:ok, result} -> if print_out, do: print(result, "Solution:"),
                                   else: result
    end
  end

  defp solve(board, position, seq_num, zbl, goal) do
    value = board[position].value
    cond do
      value > 0 and value != seq_num -> nil
      value == 0 and zbl[seq_num] -> nil
      true ->
        cell = %Cell{board[position] | value: seq_num, used: true}
        board = %{board | position => cell}
        if seq_num == goal, do: throw({:ok, board})
        Enum.each(wdof(board, cell.adj), fn pos ->
          solve(board, pos, seq_num+1, zbl, goal)
        end)
    end
  end

  defp setup(str) do
    lines = String.strip(str) |> String.split(~r/(\n|\r\n|\r)/) |> Enum.with_index
    for {line,i} <- lines, {char,j} <- Enum.with_index(String.split(line)),
        :error != Integer.parse(char), into: %{} do
          {n,_} = Integer.parse(char)
          {{i,j}, %Cell{value: n}}
        end
  end

  defp set_adj(board, adjacent) do
    Enum.reduce(Map.keys(board), board, fn {x,y},map ->
      adj = Enum.map(adjacent, fn {i,j} -> {x+i, y+j} end)
            |> Enum.reduce([], fn pos,acc -> if board[pos], do: [pos | acc], else: acc end)
      Map.update!(map, {x,y}, fn cell -> %Cell{cell | adj: adj} end)
    end)
  end

  defp wdof(board, adj) do              # Warnsdorf's rule
    Enum.reject(adj, fn pos -> board[pos].used end)
    |> Enum.sort_by(fn pos ->
         Enum.count(board[pos].adj, fn p -> not board[p].used end)
       end)
  end

  def print(board, title) do
    IO.puts "\n#{title}"
    {xmin, xmax} = Map.keys(board) |> Enum.map(fn {x,_} -> x end) |> Enum.min_max
    {ymin, ymax} = Map.keys(board) |> Enum.map(fn {_,y} -> y end) |> Enum.min_max
    len = map_size(board) |> to_char_list |> length
    space = String.duplicate(" ", len)
    Enum.each(xmin..xmax, fn x ->
      Enum.map_join(ymin..ymax, " ", fn y ->
        case Map.get(board, {x,y}) do
          nil  -> space
          cell -> to_string(cell.value) |> String.rjust(len)
        end
      end)
      |> IO.puts
    end)
  end
end
