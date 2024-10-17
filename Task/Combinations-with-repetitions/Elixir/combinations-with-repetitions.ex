defmodule RC do
  def comb_rep(0, _), do: [[]]
  def comb_rep(_, []), do: []
  def comb_rep(n, [h|t]=s) do
    (for l <- comb_rep(n-1, s), do: [h|l]) ++ comb_rep(n, t)
  end
end

s = [:iced, :jam, :plain]
Enum.each(RC.comb_rep(2, s), fn x -> IO.inspect x end)

IO.puts  "\nExtra credit: #{length(RC.comb_rep(3, Enum.to_list(1..10)))}"
