defmodule Subtractive do
  def new(seed) when seed in 0..999_999_999 do
    s = Enum.reduce(1..53, [1, seed], fn _,[a,b|_]=acc -> [b-a | acc] end)
        |> Enum.reverse
        |> List.to_tuple
    state = for i <- 1..55, do: elem(s, rem(34*i, 55))
    {:ok, _pid} = Agent.start_link(fn -> state end, name: :Subtractive)
    Enum.each(1..220, fn _ -> rand end) # Discard first 220 elements of sequence.
  end

  def rand do
    state = Agent.get(:Subtractive, &(&1))
    n = rem(Enum.at(state, -55) - Enum.at(state, -24) + 1_000_000_000, 1_000_000_000)
    :ok = Agent.update(:Subtractive, fn _ -> tl(state) ++ [n] end)
    hd(state)
  end
end

Subtractive.new(292929)
for _ <- 1..10, do: IO.puts Subtractive.rand
