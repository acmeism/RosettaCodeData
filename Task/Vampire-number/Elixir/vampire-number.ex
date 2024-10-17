defmodule Vampire do
  def factor_pairs(n) do
    first = trunc(n / :math.pow(10, div(char_len(n), 2)))
    last  = :math.sqrt(n) |> round
    for i <- first .. last, rem(n, i) == 0, do: {i, div(n, i)}
  end

  def vampire_factors(n) do
    if rem(char_len(n), 2) == 1 do
      []
    else
      half = div(length(to_char_list(n)), 2)
      sorted = Enum.sort(String.codepoints("#{n}"))
      Enum.filter(factor_pairs(n), fn {a, b} ->
        char_len(a) == half && char_len(b) == half &&
        Enum.count([a, b], fn x -> rem(x, 10) == 0 end) != 2 &&
        Enum.sort(String.codepoints("#{a}#{b}")) == sorted
      end)
    end
  end

  defp char_len(n), do: length(to_char_list(n))

  def task do
    Enum.reduce_while(Stream.iterate(1, &(&1+1)), 1, fn n, acc ->
      case vampire_factors(n) do
        [] -> {:cont, acc}
        vf -> IO.puts "#{n}:\t#{inspect vf}"
              if acc < 25, do: {:cont, acc+1}, else: {:halt, acc+1}
      end
    end)
    IO.puts ""
    Enum.each([16758243290880, 24959017348650, 14593825548650], fn n ->
      case vampire_factors(n) do
        [] -> IO.puts "#{n} is not a vampire number!"
        vf -> IO.puts "#{n}:\t#{inspect vf}"
      end
    end)
  end
end

Vampire.task
