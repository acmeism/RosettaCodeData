defmodule Rectangle do
  def cut(h, w, disp\\true) when rem(h,2)==0 or rem(w,2)==0 do
    limit = div(h * w, 2)
    start_link
    grid = make_grid(h, w)
    walk(h, w, grid, 0, 0, limit, %{}, [])
    if disp, do: display(h, w)
    result = Agent.get(__MODULE__, &(&1))
    Agent.stop(__MODULE__)
    MapSet.to_list(result)
  end

  defp start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  defp make_grid(h, w) do
    for i <- 0..h-1, j <- 0..w-1, into: %{}, do: {{i,j}, true}
  end

  defp walk(h, w, grid, x, y, limit, cut, select) do
    grid2 = grid |> Map.put({x,y}, false) |> Map.put({h-x-1,w-y-1}, false)
    select2 = [{x,y} | select] |> Enum.sort
    unless cut[select2] do
      if length(select2) == limit do
        Agent.update(__MODULE__, fn set -> MapSet.put(set, select2) end)
      else
        cut2 = Map.put(cut, select2, true)
        search_next(grid2, select2)
        |> Enum.each(fn {i,j} -> walk(h, w, grid2, i, j, limit, cut2, select2) end)
      end
    end
  end

  defp dirs(x, y), do: [{x+1, y}, {x-1, y}, {x, y-1}, {x, y+1}]

  defp search_next(grid, select) do
    (for {x,y} <- select, {i,j} <- dirs(x,y), grid[{i,j}], do: {i,j})
    |> Enum.uniq
  end

  defp display(h, w) do
    Agent.get(__MODULE__, &(&1))
    |> Enum.each(fn select ->
         grid = Enum.reduce(select, make_grid(h,w), fn {x,y},grid ->
                  %{grid | {x,y} => false}
                end)
         IO.puts to_string(h, w, grid)
       end)
  end

  defp to_string(h, w, grid) do
    text = for x <- 0..h*2, into: %{}, do: {x, String.duplicate(" ", w*4+1)}
    text = Enum.reduce(0..h, text, fn i,acc ->
             Enum.reduce(0..w, acc, fn j,txt ->
               to_s(txt, i, j, grid)
             end)
           end)
    Enum.map_join(0..h*2, "\n", fn i -> text[i] end)
  end

  defp to_s(text, i, j, grid) do
    text = if grid[{i,j}] != grid[{i-1,j}], do: replace(text, i*2, j*4+1, "---"), else: text
    text = if grid[{i,j}] != grid[{i,j-1}], do: replace(text, i*2+1, j*4, "|"), else: text
    replace(text, i*2, j*4, "+")
  end

  defp replace(text, x, y, replacement) do
    len = String.length(replacement)
    Map.update!(text, x, fn str ->
      String.slice(str, 0, y) <> replacement <> String.slice(str, y+len..-1)
    end)
  end
end

Rectangle.cut(2, 2) |> length |> IO.puts
Rectangle.cut(3, 4) |> length |> IO.puts
