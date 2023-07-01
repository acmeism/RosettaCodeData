defmodule RC do
  def range_extract(list) do
    max = Enum.max(list) + 2
    sorted = Enum.sort([max|list])
    candidate_number = hd(sorted)
    current_number = hd(sorted)
    extract(tl(sorted), candidate_number, current_number, [])
  end

  defp extract([], _, _, range), do: Enum.reverse(range) |> Enum.join(",")
  defp extract([next|rest], candidate, current, range) when current+1 >= next do
    extract(rest, candidate, next, range)
  end
  defp extract([next|rest], candidate, current, range) when candidate == current do
    extract(rest, next, next, [to_string(current)|range])
  end
  defp extract([next|rest], candidate, current, range) do
    separator = if candidate+1 == current, do: ",", else: "-"
    str = "#{candidate}#{separator}#{current}"
    extract(rest, next, next, [str|range])
  end
end

list = [
   0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
  25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
  37, 38, 39
]
IO.inspect RC.range_extract(list)
