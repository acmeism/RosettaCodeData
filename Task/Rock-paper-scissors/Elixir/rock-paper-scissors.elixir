defmodule Rock_paper_scissors do
  def play, do: loop([1,1,1])

  defp loop([r,p,s]=odds) do
    IO.gets("What is your move? (R,P,S,Q) ") |> String.upcase |> String.first
    |> case do
           "Q" -> IO.puts "Good bye!"
           human when human in ["R","P","S"] ->
              IO.puts "Your move is #{play_to_string(human)}."
              computer = select_play(odds)
              IO.puts "My move is #{play_to_string(computer)}"
              case beats(human,computer) do
                  true  -> IO.puts "You win!"
                  false -> IO.puts "I win!"
                  _     -> IO.puts "Draw"
              end
              case human do
                  "R" -> loop([r+1,p,s])
                  "P" -> loop([r,p+1,s])
                  "S" -> loop([r,p,s+1])
              end
           _ ->
              IO.puts "Invalid play"
              loop(odds)
       end
  end

  defp beats("R","S"), do: true
  defp beats("P","R"), do: true
  defp beats("S","P"), do: true
  defp beats(x,x), do: :draw
  defp beats(_,_), do: false

  defp play_to_string("R"), do: "Rock"
  defp play_to_string("P"), do: "Paper"
  defp play_to_string("S"), do: "Scissors"

  defp select_play([r,p,s]) do
    n = :rand.uniform(r+p+s)
    cond do
        n <= r   -> "P"
        n <= r+p -> "S"
        true     -> "R"
    end
  end
end

Rock_paper_scissors.play
