defmodule Table do
  defp put_rows(n) do
    Enum.map_join(1..n, fn i ->
      "<tr align=right><th>#{i}</th>" <>
      Enum.map_join(1..3, fn _ ->
        "<td>#{:rand.uniform(2000)}</td>"
      end) <> "</tr>\n"
    end)
  end

  def create_table(n\\3) do
    "<table border=1>\n" <>
    "<th></th><th>X</th><th>Y</th><th>Z</th>\n" <>
    put_rows(n) <>
    "</table>"
  end
end

IO.puts Table.create_table
