defmodule SEDOL do
  @sedol_char  "0123456789BCDFGHJKLMNPQRSTVWXYZ" |> String.codepoints
  @sedolweight  [1,3,1,7,3,9]

  defp char2value(c) do
    unless c in @sedol_char, do: raise ArgumentError, "No vowels"
    String.to_integer(c,36)
  end

  def checksum(sedol) do
    if String.length(sedol) != length(@sedolweight), do: raise ArgumentError, "Invalid length"
    sum = Enum.zip(String.codepoints(sedol), @sedolweight)
          |> Enum.map(fn {ch, weight} -> char2value(ch) * weight end)
          |> Enum.sum
    to_string(rem(10 - rem(sum, 10), 10))
  end
end

data = ~w{
          710889
          B0YBKJ
          406566
          B0YBLH
          228276
          B0YBKL
          557910
          B0YBKR
          585284
          B0YBKT
          B00030
          C0000
          1234567
          00000A
         }

Enum.each(data, fn sedol ->
  :io.fwrite "~-8s ", [sedol]
  try do
    IO.puts sedol <> SEDOL.checksum(sedol)
  rescue
    e in ArgumentError -> IO.inspect e
  end
end)
