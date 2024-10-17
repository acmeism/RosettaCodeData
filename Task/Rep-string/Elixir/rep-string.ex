defmodule Rep_string do
  def find(""), do: IO.puts "String was empty (no repetition)"
  def find(str) do
    IO.puts str
    rep_pos = Enum.find(div(String.length(str),2)..1, fn pos ->
      String.starts_with?(str, String.slice(str, pos..-1))
    end)
    if rep_pos && rep_pos>0 do
      IO.puts String.duplicate(" ", rep_pos) <> String.slice(str, 0, rep_pos)
    else
      IO.puts "(no repetition)"
    end
    IO.puts ""
  end
end

strs = ~w(1001110011
          1110111011
          0010010010
          1010101010
          1111111111
          0100101101
          0100100
          101
          11
          00
          1)

Enum.each(strs, fn str -> Rep_string.find(str) end)
