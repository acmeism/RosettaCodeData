defmodule Stem_and_leaf do
  def plot(data, leaf_digits\\1) do
    multiplier = Enum.reduce(1..leaf_digits, 1, fn _,acc -> acc*10 end)
    Enum.group_by(data, fn x -> div(x, multiplier) end)
    |> Map.new(fn {k,v} -> {k, Enum.map(v, &rem(&1, multiplier)) |> Enum.sort} end)
    |> print(leaf_digits)
  end

  defp print(plot_data, leaf_digits) do
    {min, max} = Map.keys(plot_data) |> Enum.min_max
    stem_width = length(to_charlist(max))
    fmt = "~#{stem_width}w | ~s~n"
    Enum.each(min..max, fn stem ->
      leaves = Enum.map_join(Map.get(plot_data, stem, []), " ", fn leaf ->
        to_string(leaf) |> String.pad_leading(leaf_digits)
      end)
      :io.format fmt, [stem, leaves]
    end)
  end
end

data = ~w(12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 125 139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27 44 105 99 41 128 121 116 125 32 61 37 127 29 113 121 58 114 126 53 114 96 25 109 7 31 141 46 13 27 43 117 116 27 7 68 40 31 115 124 42 128 52 71 118 117 38 27 106 33 117 116 111 40 119 47 105 57 122 109 124 115 43 120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116 146)
       |> Enum.map(&String.to_integer(&1))
Stem_and_leaf.plot(data)
