defmodule Anagrams do
  def find(file) do
    File.read!(file)
    |> String.split
    |> Enum.group_by(fn word -> String.codepoints(word) |> Enum.sort end)
    |> Enum.group_by(fn {_,v} -> length(v) end)
    |> Enum.max
    |> print
  end

  defp print({_,y}) do
    Enum.each(y, fn {_,e} -> Enum.sort(e) |> Enum.join(" ") |> IO.puts end)
  end
end

Anagrams.find("unixdict.txt")
