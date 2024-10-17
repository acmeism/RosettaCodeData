defmodule Ludic do
  def numbers(n \\ 100000) do
    [h|t] = Enum.to_list(1..n)
    numbers(t, [h])
  end

  defp numbers(list, nums) when length(list) < hd(list), do: Enum.reverse(nums, list)
  defp numbers([h|_]=list, nums) do
    Enum.drop_every(list, h) |> numbers([h | nums])
  end

  def task do
    IO.puts "First 25 : #{inspect numbers(200) |> Enum.take(25)}"
    IO.puts "Below 1000: #{length(numbers(1000))}"
    tuple = numbers(25000) |> List.to_tuple
    IO.puts "2000..2005th: #{ inspect for i <- 1999..2004, do: elem(tuple, i) }"
    ludic = numbers(250)
    triple = for x <- ludic, x+2 in ludic, x+6 in ludic, do: [x, x+2, x+6]
    IO.puts "Triples below 250: #{inspect triple, char_lists: :as_lists}"
  end
end

Ludic.task
