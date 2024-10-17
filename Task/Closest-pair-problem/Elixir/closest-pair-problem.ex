defmodule Closest_pair do
  # brute-force algorithm:
  def bruteForce([p0,p1|_] = points), do: bf_loop(points, {distance(p0, p1), {p0, p1}})

  defp bf_loop([_], acc), do: acc
  defp bf_loop([h|t], acc), do: bf_loop(t, bf_loop(h, t, acc))

  defp bf_loop(_, [], acc), do: acc
  defp bf_loop(p0, [p1|t], {minD, minP}) do
    dist = distance(p0, p1)
    if dist < minD, do: bf_loop(p0, t, {dist, {p0, p1}}),
                  else: bf_loop(p0, t, {minD, minP})
  end

  defp distance({p0x,p0y}, {p1x,p1y}) do
    :math.sqrt( (p1x - p0x) * (p1x - p0x) + (p1y - p0y) * (p1y - p0y) )
  end

  # recursive divide&conquer approach:
  def recursive(points) do
    recursive(Enum.sort(points), Enum.sort_by(points, fn {_x,y} -> y end))
  end

  def recursive(xP, _yP) when length(xP) <= 3, do: bruteForce(xP)
  def recursive(xP, yP) do
    {xL, xR} = Enum.split(xP, div(length(xP), 2))
    {xm, _} = hd(xR)
    {yL, yR} = Enum.partition(yP, fn {x,_} -> x < xm end)
    {dL, pairL} = recursive(xL, yL)
    {dR, pairR} = recursive(xR, yR)
    {dmin, pairMin} = if dL<dR, do: {dL, pairL}, else: {dR, pairR}
    yS = Enum.filter(yP, fn {x,_} -> abs(xm - x) < dmin end)
    merge(yS, {dmin, pairMin})
  end

  defp merge([_], acc), do: acc
  defp merge([h|t], acc), do: merge(t, merge_loop(h, t, acc))

  defp merge_loop(_, [], acc), do: acc
  defp merge_loop(p0, [p1|_], {dmin,_}=acc) when dmin <= elem(p1,1) - elem(p0,1), do: acc
  defp merge_loop(p0, [p1|t], {dmin, pair}) do
    dist = distance(p0, p1)
    if dist < dmin, do: merge_loop(p0, t, {dist, {p0, p1}}),
                  else: merge_loop(p0, t, {dmin, pair})
  end
end

data = [{0.654682, 0.925557}, {0.409382, 0.619391}, {0.891663, 0.888594}, {0.716629, 0.996200},
        {0.477721, 0.946355}, {0.925092, 0.818220}, {0.624291, 0.142924}, {0.211332, 0.221507},
        {0.293786, 0.691701}, {0.839186, 0.728260}]

IO.inspect Closest_pair.bruteForce(data)
IO.inspect Closest_pair.recursive(data)

data2 = for _ <- 1..5000, do: {:rand.uniform, :rand.uniform}
IO.puts "\nBrute-force:"
IO.inspect :timer.tc(fn -> Closest_pair.bruteForce(data2) end)
IO.puts "Recursive divide&conquer:"
IO.inspect :timer.tc(fn -> Closest_pair.recursive(data2) end)
