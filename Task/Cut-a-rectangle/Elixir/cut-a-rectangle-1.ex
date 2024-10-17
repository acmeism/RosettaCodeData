import  Integer

defmodule Rectangle do
  def cut_it(h, w) when is_odd(h) and is_odd(w), do: 0
  def cut_it(h, w) when is_odd(h), do: cut_it(w, h)
  def cut_it(_, 1), do: 1
  def cut_it(h, 2), do: h
  def cut_it(2, w), do: w
  def cut_it(h, w) do
    grid = List.duplicate(false, (h + 1) * (w + 1))
    t = div(h, 2) * (w + 1) + div(w, 2)
    if is_odd(w) do
      grid = grid |> List.replace_at(t, true) |> List.replace_at(t+1, true)
      walk(h, w, div(h, 2), div(w, 2) - 1, grid) + walk(h, w, div(h, 2) - 1, div(w, 2), grid) * 2
    else
      grid = grid |> List.replace_at(t, true)
      count = walk(h, w, div(h, 2), div(w, 2) - 1, grid)
      if h == w, do: count * 2,
               else: count + walk(h, w, div(h, 2) - 1, div(w, 2), grid)
    end
  end

  defp walk(h, w, y, x, grid, count\\0)
  defp walk(h, w, y, x,_grid, count) when y in [0,h] or x in [0,w], do: count+1
  defp walk(h, w, y, x, grid, count) do
    blen = (h + 1) * (w + 1) - 1
    t = y * (w + 1) + x
    grid = grid |> List.replace_at(t, true) |> List.replace_at(blen-t, true)
    Enum.reduce(next(w), count, fn {nt, dy, dx}, cnt ->
      if Enum.at(grid, t+nt), do: cnt, else: cnt + walk(h, w, y+dy, x+dx, grid)
    end)
  end

  defp next(w), do: [{w+1, 1, 0}, {-w-1, -1, 0}, {-1, 0, -1}, {1, 0, 1}]  # {next,dy,dx}
end

Enum.each(1..9, fn w ->
  Enum.each(1..w, fn h ->
    if is_even(w * h), do: IO.puts "#{w} x #{h}: #{Rectangle.cut_it(w, h)}"
  end)
end)
