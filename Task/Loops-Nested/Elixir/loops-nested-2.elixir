list = Enum.shuffle(1..20) |> Enum.chunk(5)
IO.inspect list, char_lists: :as_lists
Enum.any?(list, fn row ->
  IO.puts ""
  Enum.any?(row, fn x ->
    IO.write "#{x} "
    x == 20
  end)
end)
IO.puts "done"
