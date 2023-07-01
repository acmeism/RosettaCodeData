defmodule Bulls_and_cows do
  def play(size \\ 4) do
    secret = Enum.take_random(1..9, size) |> Enum.map(&to_string/1)
    play(size, secret)
  end

  defp play(size, secret) do
    guess = input(size)
    if guess == secret do
      IO.puts "You win!"
    else
      {bulls, cows} = count(guess, secret)
      IO.puts "  Bulls: #{bulls}; Cows: #{cows}"
      play(size, secret)
    end
  end

  defp input(size) do
    guess = IO.gets("Enter your #{size}-digit guess: ") |> String.strip
    cond do
      guess == "" ->
        IO.puts "Give up"
        exit(:normal)
      String.length(guess)==size and String.match?(guess, ~r/^[1-9]+$/) ->
        String.codepoints(guess)
      true -> input(size)
    end
  end

  defp count(guess, secret) do
    Enum.zip(guess, secret) |>
    Enum.reduce({0,0}, fn {g,s},{bulls,cows} ->
      cond do
        g == s      -> {bulls + 1, cows}
        g in secret -> {bulls, cows + 1}
        true        -> {bulls, cows}
      end
    end)
  end
end

Bulls_and_cows.play
