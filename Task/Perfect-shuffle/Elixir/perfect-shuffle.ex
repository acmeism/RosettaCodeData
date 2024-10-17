defmodule Perfect do
  def shuffle(n) do
    start = Enum.to_list(1..n)
    m = div(n, 2)
    shuffle(start, magic_shuffle(start, m), m, 1)
  end

  defp shuffle(start, start, _, step), do: step
  defp shuffle(start, deck, m, step) do
    shuffle(start, magic_shuffle(deck, m), m, step+1)
  end

  defp magic_shuffle(deck, len) do
    {left, right} = Enum.split(deck, len)
    Enum.zip(left, right)
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten
  end
end

Enum.each([8, 24, 52, 100, 1020, 1024, 10000], fn n ->
  step = Perfect.shuffle(n)
  IO.puts "#{n} : #{step}"
end)
