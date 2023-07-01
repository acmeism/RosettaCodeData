defmodule LookAndSay do
  def next(n) do
    Enum.chunk_by(to_char_list(n), &(&1))
    |> Enum.map(fn cl=[h|_] -> Enum.concat(to_char_list(length cl), [h]) end)
    |> Enum.concat
    |> List.to_integer
  end

  def sequence_from(n) do
    Stream.iterate n, &(next/1)
  end

  def main([start_str|_]) do
    {start_val,_} = Integer.parse(start_str)
    IO.inspect sequence_from(start_val) |> Enum.take 9
  end

  def main([]) do
    main(["1"])
  end
end

LookAndSay.main(System.argv)
