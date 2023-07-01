defmodule RC do
  require Integer
  def zigzag(n) do
    fmt = "~#{to_char_list(n*n-1) |> length}w "
    (for x <- 1..n, y <- 1..n, do: {x,y})
      |> Enum.sort_by(fn{x,y}->{x+y, if(Integer.is_even(x+y), do: y, else: x)} end)
      |> Enum.with_index |> Enum.sort
      |> Enum.each(fn {{_x,y},i} ->
           :io.format fmt, [i]
           if y==n, do: IO.puts ""
         end)
  end
end

RC.zigzag(5)
