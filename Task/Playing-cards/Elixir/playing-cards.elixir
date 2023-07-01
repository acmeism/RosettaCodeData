defmodule Card do
  defstruct pip: nil, suit: nil
end

defmodule Playing_cards do
  @pips   ~w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]a
  @suits  ~w[Clubs Hearts Spades Diamonds]a
  @pip_value   Enum.with_index(@pips)
  @suit_value  Enum.with_index(@suits)

  def deal( n_cards, deck ), do: Enum.split( deck, n_cards )

  def deal( n_hands, n_cards, deck ) do
    Enum.reduce(1..n_hands, {[], deck}, fn _,{acc,d} ->
      {hand, new_d} = deal(n_cards, d)
      {[hand | acc], new_d}
    end)
  end

  def deck, do: (for x <- @suits, y <- @pips, do: %Card{suit: x, pip: y})

  def print( cards ), do: IO.puts (for x <- cards, do: "\t#{inspect x}")

  def shuffle( deck ), do: Enum.shuffle( deck )

  def sort_pips( cards ), do: Enum.sort_by( cards, &@pip_value[&1.pip] )

  def sort_suits( cards ), do: Enum.sort_by( cards, &(@suit_value[&1.suit]) )

  def task do
    shuffled = shuffle( deck )
    {hand, new_deck} = deal( 3, shuffled )
    {hands, _deck} = deal( 2, 3, new_deck )
    IO.write "Hand:"
    print( hand )
    IO.puts "Hands:"
    for x <- hands, do: print(x)
  end
end

Playing_cards.task
