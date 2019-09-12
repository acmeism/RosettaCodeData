defmodule LZW do
  @encode_map  Enum.into(0..255, Map.new, &{[&1],&1})
  @decode_map  Enum.into(0..255, Map.new, &{&1,[&1]})

  def encode(str), do: encode(to_char_list(str), @encode_map, 256, [])

  defp encode([h], d, _, out), do: Enum.reverse([d[[h]] | out])
  defp encode([h|t], d, free, out) do
    val = d[[h]]
    find_match(t, [h], val, d, free, out)
  end

  defp find_match([h|t], l, lastval, d, free, out) do
    case Map.fetch(d, [h|l]) do
      {:ok, val} -> find_match(t, [h|l], val, d, free, out)
      :error     -> d1 = Map.put(d, [h|l], free)
                    encode([h|t], d1, free+1, [lastval | out])
    end
  end
  defp find_match([], _, lastval, _, _, out), do: Enum.reverse([lastval | out])

  def decode([h|t]) do
    val = @decode_map[h]
    decode(t, val, 256, @decode_map, val)
  end

  defp decode([], _, _, _, l), do: Enum.reverse(l) |> to_string
  defp decode([h|t], old, free, d, l) do
    val = if h == free, do: old ++ [List.first(old)], else: d[h]
    add = [List.last(val) | old]
    d1  = Map.put(d, free, add)
    decode(t, val, free+1, d1, val++l)
  end
end

str = "TOBEORNOTTOBEORTOBEORNOT"
IO.inspect enc = LZW.encode(str)
IO.inspect dec = LZW.decode(enc)
IO.inspect str == dec
