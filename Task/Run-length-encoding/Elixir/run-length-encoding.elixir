defmodule Run_length do
  def encode(str) when is_bitstring(str) do
    to_char_list(str) |> encode |> to_string
  end
  def encode(list) when is_list(list) do
    Enum.chunk_by(list, &(&1))
    |> Enum.flat_map(fn chars -> to_char_list(length(chars)) ++ [hd(chars)] end)
  end

  def decode(str) when is_bitstring(str) do
    Regex.scan(~r/(\d+)(.)/, str)
    |> Enum.map_join(fn [_,n,c] -> String.duplicate(c, String.to_integer(n)) end)
  end
  def decode(list) when is_list(list) do
    to_string(list) |> decode |> to_char_list
  end
end

text = [ string:    "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW",
         char_list: 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW' ]

Enum.each(text, fn {type, txt} ->
  IO.puts type
  txt                  |> IO.inspect
  |> Run_length.encode |> IO.inspect
  |> Run_length.decode |> IO.inspect
end)
