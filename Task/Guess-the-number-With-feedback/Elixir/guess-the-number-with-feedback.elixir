defmodule GuessingGame do
  def play(lower, upper) do
    play(lower, upper, Enum.random(lower .. upper))
  end
  defp play(lower, upper, number) do
    guess = Integer.parse(IO.gets "Guess a number (#{lower}-#{upper}): ")
    case guess do
      {^number, _} ->
        IO.puts "Well guessed!"
      {n, _} when n in lower..upper ->
        IO.puts if n > number, do: "Too high.", else: "Too low."
        play(lower, upper, number)
      _ ->
        IO.puts "Guess not in valid range."
        play(lower, upper, number)
    end
  end
end

GuessingGame.play(1, 100)
