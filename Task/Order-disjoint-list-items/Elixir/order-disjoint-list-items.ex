defmodule Order do
  def disjoint(m,n) do
    IO.write "#{Enum.join(m," ")} | #{Enum.join(n," ")} -> "
    Enum.chunk(n,2)
    |> Enum.reduce({m,0}, fn [x,y],{m,from} ->
         md = Enum.drop(m, from)
         if x > y and x in md and y in md do
           if Enum.find_index(md,&(&1==x)) > Enum.find_index(md,&(&1==y)) do
             new_from = max(Enum.find_index(m,&(&1==x)), Enum.find_index(m,&(&1==y))) + 1
             m = swap(m,from,x,y)
             from = new_from
           end
         end
         {m,from}
       end)
    |> elem(0)
    |> Enum.join(" ")
    |> IO.puts
  end

  defp swap(m,from,x,y) do
    ix = Enum.find_index(m,&(&1==x)) + from
    iy = Enum.find_index(m,&(&1==y)) + from
    vx = Enum.at(m,ix)
    vy = Enum.at(m,iy)
    m |> List.replace_at(ix,vy) |> List.replace_at(iy,vx)
  end
end

[ {"the cat sat on the mat", "mat cat"},
  {"the cat sat on the mat", "cat mat"},
  {"A B C A B C A B C"     , "C A C A"},
  {"A B C A B D A B E"     , "E A D A"},
  {"A B"                   , "B"},
  {"A B"                   , "B A"},
  {"A B B A"               , "B A"}     ]
|> Enum.each(fn {m,n} ->
     Order.disjoint(String.split(m),String.split(n))
   end)
