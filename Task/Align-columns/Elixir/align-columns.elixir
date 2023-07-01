defmodule Align do
  def columns(text, alignment) do
    fieldsbyrow = String.split(text, "\n", trim: true)
                  |> Enum.map(fn row -> String.split(row, "$", trim: true) end)
    maxfields = Enum.map(fieldsbyrow, fn field -> length(field) end) |> Enum.max
    colwidths = Enum.map(fieldsbyrow, fn field -> field ++ List.duplicate("", maxfields - length(field)) end)
                |> List.zip
                |> Enum.map(fn column ->
                     Tuple.to_list(column) |> Enum.map(fn col-> String.length(col) end) |> Enum.max
                   end)
    Enum.each(fieldsbyrow, fn row ->
      Enum.zip(row, colwidths)
      |> Enum.map(fn {field, width} -> adjust(field, width, alignment) end)
      |> Enum.join(" ") |> IO.puts
    end)
  end

  defp adjust(field, width, :Left),  do: String.pad_trailing(field, width)
  defp adjust(field, width, :Right), do: String.pad_leading(field, width)
  defp adjust(field, width, _),      do: :string.centre(String.to_charlist(field), width)
end

text = """
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
"""

Enum.each([:Left, :Right, :Center], fn alignment ->
  IO.puts "\n# #{alignment} Column-aligned output:"
  Align.columns(text, alignment)
end)
