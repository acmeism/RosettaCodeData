defmodule RC do
  def compare_strings(strings) do
    {length(Enum.uniq(strings))<=1, strict_ascending(strings)}
  end

  defp strict_ascending(strings) when length(strings) <= 1, do: true
  defp strict_ascending([first, second | _]) when first >= second, do: false
  defp strict_ascending([_, second | rest]), do: strict_ascending([second | rest])
end

lists = [ ~w(AA AA AA AA), ~w(AA ACB BB CC), ~w(AA CC BB), [], ["XYZ"] ]
Enum.each(lists, fn list ->
  IO.puts "#{inspect RC.compare_strings(list)}\t<= #{inspect list} "
end)
