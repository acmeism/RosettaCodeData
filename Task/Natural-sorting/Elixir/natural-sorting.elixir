defmodule Natural do
  def sorting(texts) do
    Enum.sort_by(texts, fn text -> compare_value(text) end)
  end

  defp compare_value(text) do
    text
    |> String.downcase
    |> String.replace(~r/\A(a |an |the )/, "")
    |> String.split
    |> Enum.map(fn word ->
         Regex.scan(~r/\d+|\D+/, word)
         |> Enum.map(fn [part] ->
              case Integer.parse(part) do
                {num, ""} -> num
                _         -> part
              end
            end)
       end)
  end

  def task(title, input) do
    IO.puts "\n#{title}:"
    IO.puts "< input >"
    Enum.each(input, &IO.inspect &1)
    IO.puts "< normal sort >"
    Enum.sort(input) |> Enum.each(&IO.inspect &1)
    IO.puts "< natural sort >"
    Enum.sort_by(input, &compare_value &1) |> Enum.each(&IO.inspect &1)
  end
end

[{"Ignoring leading spaces",
  ["ignore leading spaces: 2-2",   " ignore leading spaces: 2-1",
   "  ignore leading spaces: 2+0", "   ignore leading spaces: 2+1"]},

 {"Ignoring multiple adjacent spaces (m.a.s)",
  ["ignore m.a.s spaces: 2-2",   "ignore m.a.s  spaces: 2-1",
   "ignore m.a.s   spaces: 2+0", "ignore m.a.s    spaces: 2+1"]},

 {"Equivalent whitespace characters",
  ["Equiv. spaces: 3-3",    "Equiv.\rspaces: 3-2", "Equiv.\x0cspaces: 3-1",
   "Equiv.\x0bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"]},

 {"Case Indepenent sort",
  ["cASE INDEPENENT: 3-2", "caSE INDEPENENT: 3-1",
   "casE INDEPENENT: 3+0", "case INDEPENENT: 3+1"]},

 {"Numeric fields as numerics",
  ["foo100bar99baz0.txt",   "foo100bar10baz0.txt",
   "foo1000bar99baz10.txt", "foo1000bar99baz9.txt"]},

 {"Title sorts",
  ["The Wind in the Willows", "The 40th step more", "The 39 steps", "Wanda"]}
]
|> Enum.each(fn {title, input} -> Natural.task(title, input) end)
