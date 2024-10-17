$ cat simple-moving-avg.exs
#!/usr/bin/env elixir

defmodule Math do
  def average([]), do: nil
  def average(enum) do
    Enum.sum(enum) / length(enum)
  end
end

defmodule SMA do

  def sma(l, p \\ 10) do
    IO.puts("\nSimple moving average(period=#{p}):")
    Enum.chunk(l, p, 1)
    |> Enum.map(&(%{"input": &1, "avg": Float.round(Math.average(&1), 3)}))
  end

  defmacro gen_func(p) do
    quote do
      fn l -> SMA.sma(l, unquote(p)) end
    end
  end

  def read_numeric_input do
    IO.stream(:stdio, :line)
    |> Enum.map(&(String.split(&1, ~r{\s+})))
    |> List.flatten()
    |> Enum.reject(&(is_nil(&1) || String.length(&1) == 0))
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end

  def run do
    sma_func_10 = gen_func(10)
    sma_func_15 = gen_func(15)
    numbers = read_numeric_input
    sma_func_10.(numbers) |> IO.inspect
    sma_func_15.(numbers) |> IO.inspect
  end
end

SMA.run
