defmodule RC do
  def spiral_matrix(n) do
    wide = length(to_char_list(n*n-1))
    fmt = String.duplicate("~#{wide}w ", n) <> "~n"
    runs = Enum.flat_map(n..1, &[&1,&1]) |> tl
    delta = Stream.cycle([{0,1},{1,0},{0,-1},{-1,0}])
    running(Enum.zip(runs,delta),0,-1,[])
    |> Enum.with_index |> Enum.sort |>  Enum.chunk(n)
    |> Enum.each(fn row -> :io.format fmt, (for {_,i} <- row, do: i) end)
  end

  defp running([{run,{dx,dy}}|rest], x, y, track) do
    new_track = Enum.reduce(1..run, track, fn i,acc -> [{x+i*dx, y+i*dy} | acc] end)
    running(rest, x+run*dx, y+run*dy, new_track)
  end
  defp running([],_,_,track), do: track |> Enum.reverse
end

RC.spiral_matrix(5)
