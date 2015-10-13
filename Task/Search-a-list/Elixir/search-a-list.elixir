haystack = ~w(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo)

Enum.each(~w(Bush Washington), fn needle ->
  index = Enum.find_index(haystack, fn x -> x==needle end)
  if index, do: (IO.puts "#{index} #{needle}"),
            else: raise "#{needle} is not in haystack\n"
end)
