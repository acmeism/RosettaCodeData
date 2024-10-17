defmodule GuessingGame do
  def play do
    play(Enum.random(1..10))
  end

  defp play(number) do
    guess = Integer.parse(IO.gets "Guess a number (1-10): ")
    case guess do
      {^number, _} ->
        IO.puts "Well guessed!"
      {n, _} when n in 1..10 ->
        IO.puts "That's not it."
        play(number)
      _ ->
        IO.puts "Guess not in valid range."
        play(number)
    end
  end
end

GuessingGame.play
