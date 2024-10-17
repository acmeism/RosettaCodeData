defmodule Number_reversal_game do
  def start( n ) when n > 1 do
    IO.puts "Usage: #{usage(n)}"
    targets = Enum.to_list( 1..n )
    jumbleds = Enum.shuffle(targets)
    attempt = loop( targets, jumbleds, 0 )
    IO.puts "Numbers sorted in #{attempt} atttempts"
  end

  defp loop( targets, targets, attempt ), do: attempt
  defp loop( targets, jumbleds, attempt ) do
    IO.inspect jumbleds
    {n,_} = IO.gets("How many digits from the left to reverse? ") |> Integer.parse
    loop( targets, Enum.reverse_slice(jumbleds, 0, n), attempt+1 )
  end

  defp usage(n), do: "Given a jumbled list of the numbers 1 to #{n} that are definitely not in ascending order, show the list then ask the player how many digits from the left to reverse. Reverse those digits, then ask again, until all the digits end up in ascending order."
end

Number_reversal_game.start( 9 )
