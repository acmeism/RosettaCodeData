File.open(__ENV__.file, [:read], fn(file) ->
  text = IO.read(file, :all)
  leng = String.length(text)
  String.codepoints(text)
  |> Enum.group_by(&(&1))
  |> Enum.map(fn{_,value} -> length(value) end)
  |> Enum.reduce(0, fn count, entropy ->
       freq = count / leng
       entropy - freq * :math.log2(freq)
     end)
  |> IO.puts
end)
