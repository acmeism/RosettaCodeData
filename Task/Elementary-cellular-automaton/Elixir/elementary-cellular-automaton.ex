defmodule Elementary_cellular_automaton do
  def run(start_str, rule, times) do
    IO.puts "rule : #{rule}"
    each(start_str, rule_pattern(rule), times)
  end

  defp rule_pattern(rule) do
    list = Integer.to_string(rule, 2) |> String.pad_leading(8, "0")
           |> String.codepoints |> Enum.reverse
    Enum.map(0..7, fn i -> Integer.to_string(i, 2) |> String.pad_leading(3, "0") end)
    |> Enum.zip(list) |> Map.new
  end

  defp each(_, _, 0), do: :ok
  defp each(str, patterns, times) do
    IO.puts String.replace(str, "0", ".") |> String.replace("1", "#")
    str2 = String.last(str) <> str <> String.first(str)
    next_str = Enum.map_join(0..String.length(str)-1, fn i ->
      Map.get(patterns, String.slice(str2, i, 3))
    end)
    each(next_str, patterns, times-1)
  end
end

pad = String.duplicate("0", 14)
str = pad <> "1" <> pad
Elementary_cellular_automaton.run(str, 18, 25)
