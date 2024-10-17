words = File.stream!("unixdict.txt")
        |> Enum.map(&String.strip/1)
        |> Enum.group_by(&min(&1, String.reverse &1))
        |> Map.values
        |> Enum.filter(&(length &1) == 2)
IO.puts "Semordnilap pair: #{length(words)}"
IO.inspect Enum.take(words,5)
