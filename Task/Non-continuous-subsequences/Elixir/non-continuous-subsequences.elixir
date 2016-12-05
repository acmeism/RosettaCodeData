defmodule RC do
  defp masks(n) do
    maxmask = trunc(:math.pow(2, n)) - 1
    Enum.map(3..maxmask, &Integer.to_string(&1, 2))
    |> Enum.filter_map(&contains_noncont(&1), &String.rjust(&1, n, ?0)) # padding
  end

  defp contains_noncont(n) do
    Regex.match?(~r/10+1/, n)
  end

  defp apply_mask_to_list(mask, list) do
    Enum.zip(to_char_list(mask), list)
    |> Enum.filter_map(fn {include, _} -> include > ?0 end, fn {_, value} -> value end)
  end

  def ncs(list) do
    Enum.map(masks(length(list)), fn mask -> apply_mask_to_list(mask, list) end)
  end
end

IO.inspect RC.ncs([1,2,3])
IO.inspect RC.ncs([1,2,3,4])
IO.inspect RC.ncs('abcd')
