defmodule RC do
  def reverse_words(txt) do
    txt |> String.split("\n")       # split lines
        |> Enum.map(&(              # in each line
             &1 |> String.split       # split words
                |> Enum.reverse       # reverse words
                |> Enum.join(" ")))   # rejoin words
        |> Enum.join("\n")          # rejoin lines
  end
end
