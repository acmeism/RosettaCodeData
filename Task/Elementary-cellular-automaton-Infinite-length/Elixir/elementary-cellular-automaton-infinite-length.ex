defmodule Elementary_cellular_automaton do
  def infinite(cell, rule, times) do
    each(cell, rule_pattern(rule), times)
  end

  defp each(_, _, 0), do: :ok
  defp each(cells, rules, times) do
    IO.write String.duplicate(" ", times)
    IO.puts String.replace(cells, "0", ".") |> String.replace("1", "#")
    c = not_cell(String.first(cells)) <> cells <> not_cell(String.last(cells))
    next_cells = Enum.map_join(0..String.length(cells)+1, fn i ->
      Map.get(rules, String.slice(c, i, 3))
    end)
    each(next_cells, rules, times-1)
  end

  defp not_cell("0"), do: "11"
  defp not_cell("1"), do: "00"

  defp rule_pattern(rule) do
    list = Integer.to_string(rule, 2) |> String.pad_leading(8, "0")
           |> String.codepoints |> Enum.reverse
    Enum.map(0..7, fn i -> Integer.to_string(i, 2) |> String.pad_leading(3, "0") end)
    |> Enum.zip(list) |> Map.new
  end
end

Enum.each([18, 30], fn rule ->
  IO.puts "\nRule : #{rule}"
  Elementary_cellular_automaton.infinite("1", rule, 25)
end)
