defmodule IQ_Puzzle do
  def task(i \\ 0, n \\ 5) do
    fmt = Enum.map_join(1..n, fn i ->
            String.duplicate(" ", n-i) <> String.duplicate("~w ", i) <> "~n"
          end)
    pegs = Tuple.duplicate(1, div(n*(n+1),2)) |> put_elem(i, 0)
    rest = tuple_size(pegs) - 1
    next = next_list(n)
    :io.format fmt, Tuple.to_list(pegs)
    result = Enum.find_value(next, fn nxt -> solve(pegs, rest, nxt, next, fmt) end)
    IO.puts  if result, do: result, else: "No solution found"
  end

  defp solve(_,1,_,_,_), do: "Solved"
  defp solve(pegs,rest,{g0,g1,g2},next,fmt) do
    if s = jump(pegs, g0, g1, g2) do
      peg2 = Enum.reduce([g0,g1,g2], pegs, fn g,acc ->
               put_elem(acc, g, 1-elem(acc, g))
             end)
      result = Enum.find_value(next, fn g -> solve(peg2, rest-1, g, next, fmt) end)
      if result do
        [(:io_lib.format "~n~s~n", [s]), (:io_lib.format fmt, Tuple.to_list(peg2)) | result]
      end
    end
  end

  defp jump(pegs, _0, g1, _2) when elem(pegs,g1)==0, do: nil
  defp jump(pegs, g0, _1, g2) when elem(pegs,g0)==0, do: if elem(pegs, g2)==1, do: "#{g2} to #{g0}"
  defp jump(pegs, g0, _1, g2)                      , do: if elem(pegs, g2)==0, do: "#{g0} to #{g2}"

  defp next_list(n) do
    points = for x <- 1..n, y <- 1..x, do: {x,y}
    board = points |> Enum.with_index |> Enum.into(Map.new)
    Enum.flat_map(points, fn {x,y} ->
      [ {board[{x,y}], board[{x,  y+1}], board[{x,  y+2}]},
        {board[{x,y}], board[{x+1,y  }], board[{x+2,y  }]},
        {board[{x,y}], board[{x+1,y+1}], board[{x+2,y+2}]} ]
    end)
    |> Enum.filter(fn {_,_,p} -> p end)
  end
end

IQ_Puzzle.task
