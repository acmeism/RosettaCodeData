defmodule Benfords_law do
  def distribution(n), do: :math.log10( 1 + (1 / n) )

  def task(total \\ 1000) do
    IO.puts "Digit	Actual	Benfords expected"
    fib(total)
    |> Enum.group_by(fn i -> hd(to_char_list(i)) end)
    |> Enum.map(fn {key,list} -> {key - ?0, length(list)} end)
    |> Enum.sort
    |> Enum.each(fn {x,len} -> IO.puts "#{x}	#{len / total}	#{distribution(x)}" end)
  end

  defp fib(n) do                        # suppresses zero
    Stream.unfold({1,1}, fn {a,b} -> {a,{b,a+b}} end) |> Enum.take(n)
  end
end

Benfords_law.task
