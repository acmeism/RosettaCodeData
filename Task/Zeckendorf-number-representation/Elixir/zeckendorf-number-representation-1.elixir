defmodule Zeckendorf do
  def number do
    Stream.unfold(0, fn n -> zn_loop(n) end)
  end

  defp zn_loop(n) do
    bin = Integer.to_string(n, 2)
    if String.match?(bin, ~r/11/), do: zn_loop(n+1), else: {bin, n+1}
  end
end

Zeckendorf.number |> Enum.take(21) |> Enum.with_index
|> Enum.each(fn {zn, i} -> IO.puts "#{i}: #{zn}" end)
