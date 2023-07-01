defmodule ZhangSuen do
  @neighbours  [{-1,0},{-1,1},{0,1},{1,1},{1,0},{1,-1},{0,-1},{-1,-1}]  # 8 neighbours

  def thinning(str, black \\ ?#) do
    s0 = for {line, i} <- (String.split(str, "\n") |> Enum.with_index),
             {c, j}    <- (to_char_list(line) |> Enum.with_index),
             into: Map.new,
             do: {{i,j}, (if c==black, do: 1, else: 0)}
    {xrange, yrange} = range(s0)
    print(s0, xrange, yrange)
    s1 = thinning_loop(s0, xrange, yrange)
    print(s1, xrange, yrange)
  end

  defp thinning_loop(s0, xrange, yrange) do
    s1 = step(s0, xrange, yrange, 1)            # Step 1
    s2 = step(s1, xrange, yrange, 0)            # Step 2
    if Map.equal?(s0, s2), do: s2, else: thinning_loop(s2, xrange, yrange)
  end

  defp step(s, xrange, yrange, g) do
    for x <- xrange, y <- yrange, into: Map.new, do: {{x,y}, s[{x,y}] - zs(s,x,y,g)}
  end

  defp zs(s, x, y, g) do
    if get(s,x,y) == 0 or                                       # P1
      (get(s,x-1,y) + get(s,x,y+1) + get(s,x+g,y-1+g)) == 3 or  # P2, P4, P6/P8
      (get(s,x-1+g,y+g) + get(s,x+1,y) + get(s,x,y-1)) == 3 do  # P4/P2, P6, P8
      0
    else
      next = for {i,j} <- @neighbours, do: get(s, x+i, y+j)
      bp1 = Enum.sum(next)                                      # B(P1)
      if bp1 in 2..6 do
        ap1 = (next++[hd(next)]) |> Enum.chunk(2,1) |> Enum.count(fn [a,b] -> a<b end)  # A(P1)
        if ap1 == 1, do: 1, else: 0
      else
        0
      end
    end
  end

  defp get(map, x, y), do: Map.get(map, {x,y}, 0)

  defp range(map), do: range(Map.keys(map), 0, 0)
  defp range([], xmax, ymax), do: {0 .. xmax, 0 .. ymax}
  defp range([{x,y} | t], xmax, ymax), do: range(t, max(x,xmax), max(y,ymax))

  @display  %{0 => " ", 1 => "#"}
  defp print(map, xrange, yrange) do
    Enum.each(xrange, fn x ->
      IO.puts (for y <- yrange, do: @display[map[{x,y}]])
    end)
  end
end

str = """
...........................................................
.#################...................#############.........
.##################...............################.........
.###################............##################.........
.########.....#######..........###################.........
...######.....#######.........#######.......######.........
...######.....#######........#######.......................
...#################.........#######.......................
...###############...........#######.......................
...#################.........#######.......................
...######....########........#######.......................
...######.....#######........#######.......................
...######.....#######.........#######.......######.........
.########.....#######..........###################.........
.########.....#######..#####....##################.######..
.########.....#######..#####......################.######..
.########.....#######..#####.........#############.######..
...........................................................
"""
ZhangSuen.thinning(str)

str = """
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000
"""
ZhangSuen.thinning(str, ?1)
