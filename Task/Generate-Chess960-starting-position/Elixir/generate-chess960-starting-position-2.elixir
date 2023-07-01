defmodule Chess960 do
  def construct do
    row = Enum.reduce(~w[♕ ♘ ♘], ~w[♖ ♔ ♖], fn piece,acc ->
            List.insert_at(acc, :rand.uniform(length(acc)+1)-1, piece)
          end)
    [Enum.random([0, 2, 4, 6]), Enum.random([1, 3, 5, 7])]
    |> Enum.sort
    |> Enum.reduce(row, fn pos,acc -> List.insert_at(acc, pos, "♗") end)
    |> Enum.join
  end
end

Enum.each(1..5, fn _ -> IO.puts Chess960.construct end)
