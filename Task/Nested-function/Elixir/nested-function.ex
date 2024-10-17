defmodule Nested do
  def makeList(separator) do
    counter = 1

    makeItem = fn {}, item ->
                      {"#{counter}#{separator}#{item}\n", counter+1}
                  {result, counter}, item ->
                      {result <> "#{counter}#{separator}#{item}\n", counter+1}
               end

    {} |> makeItem.("first") |> makeItem.("second") |> makeItem.("third") |> elem(0)
  end
end

IO.write Nested.makeList(". ")
