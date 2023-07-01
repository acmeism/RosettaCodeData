defmodule Card do
  @faces   ~w(2 3 4 5 6 7 8 9 10 j q k a)
  @suits   ~w(♥ ♦ ♣ ♠)                          # ~w(h d c s)
  @ordinal @faces |> Enum.with_index |> Map.new

  defstruct ~w[face suit ordinal]a

  def new(str) do
    {face, suit} = String.split_at(str, -1)
    if face in @faces and suit in @suits do
      ordinal = @ordinal[face]
      %__MODULE__{face: face, suit: suit, ordinal: ordinal}
    else
      raise ArgumentError, "invalid card: #{str}"
    end
  end

  def deck do
    for face <- @faces, suit <- @suits, do: "#{face}#{suit}"
  end
end

defmodule Hand do
  @ranks ~w(high-card one-pair two-pair three-of-a-kind straight flush
            full-house four-of-a-kind straight-flush five-of-a-kind)a |>
         Enum.with_index |> Map.new
  @wheel_faces ~w(2 3 4 5 a)

  def new(str_of_cards) do
    cards = String.downcase(str_of_cards) |>
            String.split([" ", ","], trim: true) |>
            Enum.map(&Card.new &1)
    grouped = Enum.group_by(cards, &(&1.ordinal)) |> Map.values
    face_pattern = Enum.map(grouped, &(length &1)) |> Enum.sort
    {consecutive, wheel_faces} = consecutive?(cards)
    rank = categorize(cards, face_pattern, consecutive)
    rank_num = @ranks[rank]
    tiebreaker = if wheel_faces do
                   for ord <- 3..-1, do: {1,ord}
                 else
                   Enum.map(grouped, &{length(&1), hd(&1).ordinal}) |>
                   Enum.sort |> Enum.reverse
                 end
    {rank_num, tiebreaker, str_of_cards, rank}
  end

  defp one_suit?(cards) do
    Enum.map(cards, &(&1.suit)) |> Enum.uniq |> length == 1
  end

  defp consecutive?(cards) do
    sorted = Enum.sort_by(cards, &(&1.ordinal))
    if Enum.map(sorted, &(&1.face)) == @wheel_faces do
      {true, true}
    else
      flag = Enum.map(sorted, &(&1.ordinal)) |>
             Enum.chunk(2,1) |>
             Enum.all?(fn [a,b] -> a+1 == b end)
      {flag, false}
    end
  end

  defp categorize(cards, face_pattern, consecutive) do
    case {consecutive, one_suit?(cards)} do
      {true, true}  -> :"straight-flush"
      {true, false} -> :straight
      {false, true} -> :flush
      _ ->  case face_pattern do
              [1,1,1,1,1] -> :"high-card"
              [1,1,1,2]   -> :"one-pair"
              [1,2,2]     -> :"two-pair"
              [1,1,3]     -> :"three-of-a-kind"
              [2,3]       -> :"full-house"
              [1,4]       -> :"four-of-a-kind"
              [5]         -> :"five-of-a-kind"
            end
    end
  end
end

test_hands = """
2♥ 2♦ 2♣ k♣ q♦
2♥ 5♥ 7♦ 8♣ 9♠
a♥ 2♦ 3♣ 4♣ 5♦
2♥ 3♥ 2♦ 3♣ 3♦
2♥ 7♥ 2♦ 3♣ 3♦
2♥ 6♥ 2♦ 3♣ 3♦
10♥ j♥ q♥ k♥ a♥
4♥ 4♠ k♠ 2♦ 10♠
4♥ 4♠ k♠ 3♦ 10♠
q♣ 10♣ 7♣ 6♣ 4♣
q♣ 10♣ 7♣ 6♣ 3♣
9♥ 10♥ q♥ k♥ j♣
2♥ 3♥ 4♥ 5♥ a♥
2♥ 2♥ 2♦ 3♣ 3♦
"""
hands = String.split(test_hands, "\n", trim: true) |> Enum.map(&Hand.new(&1))
IO.puts "High to low"
Enum.sort(hands) |> Enum.reverse |>
Enum.each(fn hand -> IO.puts "#{elem(hand,2)}: \t#{elem(hand,3)}" end)

# Extra Credit 2. Examples:
IO.puts "\nExtra Credit 2"
extra_hands = """
joker  2♦  2♠  k♠  q♦
joker  5♥  7♦  8♠  9♦
joker  2♦  3♠  4♠  5♠
joker  3♥  2♦  3♠  3♦
joker  7♥  2♦  3♠  3♦
joker  7♥  7♦  7♠  7♣
joker  j♥  q♥  k♥  A♥
joker  4♣  k♣  5♦ 10♠
joker  k♣  7♣  6♣  4♣
joker  2♦  joker  4♠  5♠
joker  Q♦  joker  A♠ 10♠
joker  Q♦  joker  A♦ 10♦
joker  2♦  2♠  joker  q♦
"""
deck = Card.deck
String.split(extra_hands, "\n", trim: true) |>
Enum.each(fn hand ->
  [a,b,c,d,e] = String.split(hand) |>
                Enum.map(fn c -> if c=="joker", do: deck, else: [c] end)
  cards_list = for v<-a, w<-b, x<-c, y<-d, z<-e, do: "#{v} #{w} #{x} #{y} #{z}"
  best = Enum.map(cards_list, &Hand.new &1) |> Enum.max
  IO.puts "#{hand}:\t#{elem(best,3)}"
end)
