defmodule Penney do
  @toss [:Heads, :Tails]

  def game(score \\ {0,0})
  def game({iwin, ywin}=score) do
    IO.puts "Penney game score  I : #{iwin}, You : #{ywin}"
    [i, you] = @toss
    coin = Enum.random(@toss)
    IO.puts "#{i} I start, #{you} you start ..... #{coin}"
    {myC, yC} = setup(coin)
    seq = for _ <- 1..3, do: Enum.random(@toss)
    IO.write Enum.join(seq, " ")
    {winner, score} = loop(seq, myC, yC, score)
    IO.puts "\n #{winner} win!\n"
    game(score)
  end

  defp setup(:Heads) do
    myC = Enum.shuffle(@toss) ++ [Enum.random(@toss)]
    joined = Enum.join(myC, " ")
    IO.puts "I chose  : #{joined}"
    {myC, yourChoice}
  end
  defp setup(:Tails) do
    yC = yourChoice
    myC = (@toss -- [Enum.at(yC,1)]) ++ Enum.take(yC,2)
    joined = Enum.join(myC, " ")
    IO.puts "I chose  : #{joined}"
    {myC, yC}
  end

  defp yourChoice do
    IO.write "Enter your choice (H/T) "
    choice = read([])
    IO.puts "You chose: #{Enum.join(choice, " ")}"
    choice
  end

  defp read([_,_,_]=choice), do: choice
  defp read(choice) do
    case IO.getn("") |> String.upcase do
      "H" -> read(choice ++ [:Heads])
      "T" -> read(choice ++ [:Tails])
      _   -> read(choice)
    end
  end

  defp loop(myC, myC, _, {iwin, ywin}), do: {"I", {iwin+1, ywin}}
  defp loop(yC,  _,  yC, {iwin, ywin}), do: {"You", {iwin, ywin+1}}
  defp loop(seq, myC, yC, score) do
    append = Enum.random(@toss)
    IO.write " #{append}"
    loop(tl(seq)++[append], myC, yC, score)
  end
end

Penney.game
