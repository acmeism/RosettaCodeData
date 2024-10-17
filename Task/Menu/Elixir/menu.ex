defmodule Menu do
  def select(_, []), do: ""
  def select(prompt, items) do
    IO.puts ""
    Enum.with_index(items) |> Enum.each(fn {item,i} -> IO.puts " #{i}. #{item}" end)
    answer = IO.gets("#{prompt}: ") |> String.strip
    case Integer.parse(answer) do
      {num, ""} when num in 0..length(items)-1 -> Enum.at(items, num)
      _ -> select(prompt, items)
    end
  end
end

# test empty list
response = Menu.select("Which is empty", [])
IO.puts "empty list returns: #{inspect response}"

# "real" test
items = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]
response = Menu.select("Which is from the three pigs", items)
IO.puts "you chose: #{inspect response}"
