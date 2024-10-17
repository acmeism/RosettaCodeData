defmodule Roman_numeral do
  def decode([]), do: 0
  def decode([x]), do: to_value(x)
  def decode([h1, h2 | rest]) do
    case {to_value(h1), to_value(h2)} do
      {v1, v2} when v1 < v2 -> v2 - v1 + decode(rest)
      {v1, _} -> v1 + decode([h2 | rest])
    end
  end

  defp to_value(?M), do: 1000
  defp to_value(?D), do:  500
  defp to_value(?C), do:  100
  defp to_value(?L), do:   50
  defp to_value(?X), do:   10
  defp to_value(?V), do:    5
  defp to_value(?I), do:    1
end

Enum.each(['MCMXC', 'MMVIII', 'MDCLXVI', 'IIIID'], fn clist ->
  IO.puts "#{clist}\t: #{Roman_numeral.decode(clist)}"
end)
