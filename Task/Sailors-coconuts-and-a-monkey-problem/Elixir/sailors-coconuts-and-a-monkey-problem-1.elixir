defmodule RC do
  def valid?(sailor, nuts), do: valid?(sailor, nuts, sailor)

  def valid?(sailor, nuts, 0), do: nuts > 0 and rem(nuts,sailor) == 0
  def valid?(sailor, nuts, _) when rem(nuts,sailor)!=1, do: false
  def valid?(sailor, nuts, i) do
    valid?(sailor, nuts - div(nuts,sailor) - 1, i-1)
  end
end

Enum.each([5,6], fn sailor ->
  nuts = Enum.find(Stream.iterate(sailor, &(&1+1)), fn n -> RC.valid?(sailor, n) end)
  IO.puts "\n#{sailor} sailors => #{nuts} coconuts"
  Enum.reduce(0..sailor, nuts, fn _,n ->
    {d, r} = {div(n,sailor), rem(n,sailor)}
    IO.puts "  #{inspect [n, d, r]}"
    n - 1 - d
  end)
end)
