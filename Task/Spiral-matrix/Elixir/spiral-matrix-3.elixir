defmodule RC do
  def spiral_matrix(n) do
    fmt = String.duplicate("~#{length(to_char_list(n*n-1))}w ", n) <> "~n"
    Enum.flat_map(n..1, &[&1, &1])
    |> tl
    |> Enum.reduce({{0,-1},{0,1},[]}, fn run,{{x,y},{dx,dy},acc} ->
         side = for i <- 1..run, do: {x+i*dx, y+i*dy}
         {{x+run*dx, y+run*dy}, {dy, -dx}, acc++side}
       end)
    |> elem(2)
    |> Enum.with_index
    |> Enum.sort
    |> Enum.map(fn {_,i} -> i end)
    |> Enum.chunk(n)
    |> Enum.each(fn row -> :io.format fmt, row end)
  end
end

RC.spiral_matrix(5)
