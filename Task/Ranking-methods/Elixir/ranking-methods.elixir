defmodule Ranking do
  def methods(data) do
    IO.puts "stand.\tmod.\tdense\tord.\tfract."
    Enum.group_by(data, fn {score,_name} -> score end)
    |> Enum.map(fn {score,pairs} ->
         names = Enum.map(pairs, fn {_,name} -> name end) |> Enum.reverse
         {score, names}
       end)
    |> Enum.sort_by(fn {score,_} -> -score end)
    |> Enum.with_index
    |> Enum.reduce({1,0,0}, fn {{score, names}, i}, {s_rnk, m_rnk, o_rnk} ->
         d_rnk = i + 1
         m_rnk = m_rnk + length(names)
         f_rnk = ((s_rnk + m_rnk) / 2) |> to_string |> String.replace(".0","")
         o_rnk = Enum.reduce(names, o_rnk, fn name,acc ->
           IO.puts "#{s_rnk}\t#{m_rnk}\t#{d_rnk}\t#{acc+1}\t#{f_rnk}\t#{score} #{name}"
           acc + 1
         end)
         {s_rnk+length(names), m_rnk, o_rnk}
       end)
  end
end

~w"44 Solomon
   42 Jason
   42 Errol
   41 Garry
   41 Bernard
   41 Barry
   39 Stephen"
|> Enum.chunk(2)
|> Enum.map(fn [score,name] -> {String.to_integer(score),name} end)
|> Ranking.methods
