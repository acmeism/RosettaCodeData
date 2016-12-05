file = hd(System.argv)

File.read!(file)
|> String.upcase
|> String.graphemes
|> Enum.filter(fn c -> c =~ ~r/[A-Z]/ end)
|> Enum.reduce(Map.new, fn c,acc -> Map.update(acc, c, 1, &(&1+1)) end)
|> Enum.sort_by(fn {_k,v} -> -v end)
|> Enum.each(fn {k,v} -> IO.puts "#{k}  #{v}" end)
