defmodule Luhn do
  def valid?(cc) when is_binary(cc), do: String.to_integer(cc) |> valid?
  def valid?(cc) when is_integer(cc) do
    0 == Integer.digits(cc)
         |> Enum.reverse
         |> Enum.chunk(2, 2, [0])
         |> Enum.reduce(0, fn([odd, even], sum) -> Enum.sum([sum, odd | Integer.digits(even*2)]) end)
         |> rem(10)
  end
end

numbers = ~w(49927398716 49927398717 1234567812345678 1234567812345670)
for n <- numbers, do: IO.puts "#{n}: #{Luhn.valid?(n)}"
