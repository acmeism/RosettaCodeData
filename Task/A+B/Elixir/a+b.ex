IO.gets("Enter two numbers seperated by a space: ")
  |> String.split
  |> Enum.map(&String.to_integer(&1))
  |> Enum.sum
  |> IO.puts
