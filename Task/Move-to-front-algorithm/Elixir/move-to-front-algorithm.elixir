defmodule MoveToFront do
  @table  Enum.to_list(?a..?z)

  def encode(text), do: encode(to_char_list(text), @table, [])

  defp encode([], _, output), do: Enum.reverse(output)
  defp encode([h|t], table, output) do
    i = Enum.find_index(table, &(&1 == h))
    encode(t, move2front(table, i), [i | output])
  end

  def decode(indices), do: decode(indices, @table, [])

  defp decode([], _, output), do: Enum.reverse(output) |> to_string
  defp decode([h|t], table, output) do
    decode(t, move2front(table, h), [Enum.at(table, h) | output])
  end

  def move2front(table, i), do: [Enum.at(table,i) | List.delete_at(table, i)]
end

Enum.each(["broood", "bananaaa", "hiphophiphop"], fn word ->
  IO.inspect word
  IO.inspect enc = MoveToFront.encode(word)
  IO.puts "#{word == MoveToFront.decode(enc)}\n"
end)
