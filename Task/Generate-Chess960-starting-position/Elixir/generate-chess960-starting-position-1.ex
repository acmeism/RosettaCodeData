defmodule Chess960 do
  @pieces   ~w(♔ ♕ ♘ ♘ ♗ ♗ ♖ ♖)             # ~w(K Q N N B B R R)
  @regexes  [~r/♗(..)*♗/, ~r/♖.*♔.*♖/]        # [~r/B(..)*B/, ~r/R.*K.*R/]

  def shuffle do
    row = Enum.shuffle(@pieces) |> Enum.join
    if Enum.all?(@regexes, &Regex.match?(&1, row)), do: row, else: shuffle
  end
end

Enum.each(1..5, fn _ -> IO.puts Chess960.shuffle end)
