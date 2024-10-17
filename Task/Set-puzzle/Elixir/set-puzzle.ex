defmodule RC do
  def set_puzzle(deal, goal) do
    {puzzle, sets} = get_puzzle_and_answer(deal, goal, produce_deck)
    IO.puts "Dealt #{length(puzzle)} cards:"
    print_cards(puzzle)
    IO.puts "Containing #{length(sets)} sets:"
    Enum.each(sets, fn set -> print_cards(set) end)
  end

  defp get_puzzle_and_answer(hand_size, num_sets_goal, deck) do
    hand = Enum.take_random(deck, hand_size)
    sets = get_all_sets(hand)
    if length(sets) == num_sets_goal do
      {hand, sets}
    else
      get_puzzle_and_answer(hand_size, num_sets_goal, deck)
    end
  end

  defp get_all_sets(hand) do
    Enum.filter(comb(hand, 3), fn candidate ->
      List.flatten(candidate)
      |> Enum.group_by(&(&1))
      |> Map.values
      |> Enum.all?(fn v -> length(v) != 2 end)
    end)
  end

  defp print_cards(cards) do
    Enum.each(cards, fn card ->
      :io.format "  ~-8s  ~-8s  ~-8s  ~-8s~n", card
    end)
    IO.puts ""
  end

  @colors   ~w(red green purple)a
  @symbols  ~w(oval squiggle diamond)a
  @numbers  ~w(one two three)a
  @shadings ~w(solid open striped)a

  defp produce_deck do
    for color <- @colors, symbol <- @symbols, number <- @numbers, shading <- @shadings,
      do: [color, symbol, number, shading]
  end

  defp comb(_, 0), do: [[]]
  defp comb([], _), do: []
  defp comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end

RC.set_puzzle(9, 4)
RC.set_puzzle(12, 6)
