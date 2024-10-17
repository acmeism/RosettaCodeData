File.read!("unixdict.txt")
|> String.split
|> Enum.filter(fn word -> String.codepoints(word) |> Enum.sort |> Enum.join == word end)
|> Enum.group_by(fn word -> String.length(word) end)
|> Enum.max_by(fn {length,_words} -> length end)
|> elem(1)
|> Enum.sort
|> Enum.each(fn word -> IO.puts word end)
