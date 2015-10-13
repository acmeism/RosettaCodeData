defmodule RC do
  use Bitwise
  def powerset1(list) do
    n = length(list)
    max = round(:math.pow(2,n))
    for i <- 0..max-1, do: (for pos <- 0..n-1, band(i, bsl(1, pos)) != 0, do: Enum.at(list, pos) )
  end

  def powerset2([]), do: [[]]
  def powerset2([h|t]) do
    pt = powerset2(t)
    (for x <- pt, do: [h|x]) ++ pt
  end

  def powerset3([]), do: [[]]
  def powerset3([h|t]) do
    pt = powerset3(t)
    powerset3(h, pt, pt)
  end

  defp powerset3(_, [], acc), do: acc
  defp powerset3(x, [h|t], acc), do: powerset3(x, t, [[x|h] | acc])
end

IO.inspect RC.powerset1([1,2,3])
IO.inspect RC.powerset2([1,2,3])
IO.inspect RC.powerset3([1,2,3])
IO.inspect RC.powerset1([])
IO.inspect RC.powerset1(["one"])
