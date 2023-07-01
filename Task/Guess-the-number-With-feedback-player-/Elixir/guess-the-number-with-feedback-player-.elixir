defmodule Game do
  def guess(a..b) do
    x = Enum.random(a..b)
    guess(x, a..b, div(a+b, 2))
  end

  defp guess(x, a.._b, guess) when x < guess do
    IO.puts "Is it #{guess}? Too High."
    guess(x, a..guess-1, div(a+guess, 2))
  end
  defp guess(x, _a..b, guess) when x > guess do
    IO.puts "Is it #{guess}? Too Low."
    guess(x, guess+1..b, div(guess+b+1, 2))
  end
  defp guess(x, _, _) do
    IO.puts "Is it #{x}?"
    IO.puts " So the number is: #{x}"
  end
end
Game.guess(1..100)
