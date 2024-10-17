defmodule FreeCell do
  import Bitwise

  @suits ~w( C D H S )
  @pips ~w( A 2 3 4 5 6 7 8 9 T J Q K )
  @orig_deck for pip <- @pips, suit <- @suits, do: pip <> suit

  def deal(games) do
    games = if length(games) == 0, do: [Enum.random(1..32000)], else: games
    Enum.each(games, fn seed ->
      IO.puts "Game ##{seed}"
      Enum.reduce(52..2, {seed,@orig_deck}, fn len,{state,deck} ->
        state = ((214013 * state) + 2531011) &&& 0x7fff_ffff
        index = rem(state >>> 16, len)
        last = len - 1
        {a, b} = {Enum.at(deck, index), Enum.at(deck, last)}
        {state, deck |> List.replace_at(index, b) |> List.replace_at(last, a)}
      end)
      |> elem(1)
      |> Enum.reverse
      |> Enum.chunk(8,8,[])
      |> Enum.each(fn row -> Enum.join(row, " ") |> IO.puts end)
      IO.puts ""
    end)
  end
end

System.argv |> Enum.map(&String.to_integer/1)
|> FreeCell.deal
