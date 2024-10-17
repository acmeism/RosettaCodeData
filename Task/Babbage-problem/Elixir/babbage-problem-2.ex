Stream.iterate(2, &(&1+2))
|> Enum.find(&rem(&1*&1, 1000000) == 269696)
|> IO.puts
