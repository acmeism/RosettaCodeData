Enum.reduce(0..6, '0', fn _,s ->
  IO.puts s
  s ++ Enum.map(s, fn c -> if c==?0, do: ?1, else: ?0 end)
end)

# or
Stream.iterate('0', fn s -> s ++ Enum.map(s, fn c -> if c==?0, do: ?1, else: ?0 end) end)
|> Enum.take(7)
|> Enum.each(&IO.puts/1)
