iex(10)> :timer.tc(fn -> Enum.each(1..100000, fn x -> x*x end) end)
{236000, :ok}
