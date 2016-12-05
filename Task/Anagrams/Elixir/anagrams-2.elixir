File.stream!("unixdict.txt")
  |> Stream.map(&String.strip &1)
  |> Enum.group_by(&String.codepoints(&1) |> Enum.sort)
  |> Map.values
  |> Enum.group_by(&length &1)
  |> Enum.max
  |> elem(1)
  |> Enum.each(fn n -> Enum.sort(n) |> Enum.join(" ") |> IO.puts end)
