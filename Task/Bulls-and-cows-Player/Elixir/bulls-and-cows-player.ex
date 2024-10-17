defmodule Bulls_and_cows do
  def player(size \\ 4) do
    possibility = permute(size) |> Enum.shuffle
    player(size, possibility, 1)
  end

  def player(size, possibility, i) do
    guess = hd(possibility)
    IO.puts "Guess #{i} is #{Enum.join(guess)}  (from #{length(possibility)} possibilities)"
    case get_score(size) do
      {^size, 0} -> IO.puts "Solved!"
      score ->
        case select(size, possibility, guess, score) do
          [] -> IO.puts "Sorry! I can't find a solution. Possible mistake in the scoring."
          selected -> player(size, selected, i+1)
        end
    end
  end

  defp get_score(size) do
    IO.gets("Answer (Bulls, cows)? ")
    |> String.split(~r/\D/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> case do
         [bulls, cows] when bulls+cows in 0..size -> {bulls, cows}
         _ -> get_score(size)
       end
  end

  defp select(size, possibility, guess, score) do
    Enum.filter(possibility, fn x ->
      bulls = Enum.zip(x, guess) |> Enum.count(fn {n,g} -> n==g end)
      cows = size - length(x -- guess) - bulls
      {bulls, cows} == score
    end)
  end

  defp permute(size), do: permute(size, Enum.to_list(1..9))
  defp permute(0, _), do: [[]]
  defp permute(size, list) do
    for x <- list, y <- permute(size-1, list--[x]), do: [x|y]
  end
end

Bulls_and_cows.player
