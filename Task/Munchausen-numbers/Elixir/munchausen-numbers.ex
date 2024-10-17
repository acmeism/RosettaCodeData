defmodule Munchausen do
  @pow  for i <- 0..9, into: %{}, do: {i, :math.pow(i,i) |> round}

  def number?(n) do
    n == Integer.digits(n) |> Enum.reduce(0, fn d,acc -> @pow[d] + acc end)
  end
end

Enum.each(1..5000, fn i ->
  if Munchausen.number?(i), do: IO.puts i
end)
