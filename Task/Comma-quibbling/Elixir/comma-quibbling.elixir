defmodule RC do
  def generate( list ), do: "{#{ generate_content(list) }}"

  defp generate_content( [] ), do: ""
  defp generate_content( [x] ), do: x
  defp generate_content( [x1, x2] ), do: "#{x1} and #{x2}"
  defp generate_content( xs ) do
    [last, second_to_last | t] = Enum.reverse( xs )
    with_commas = for x <- t, do: x <> ","
    Enum.join(Enum.reverse([last, "and", second_to_last | with_commas]), " ")
  end
end

Enum.each([[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]], fn list ->
  IO.inspect RC.generate(list)
end)
