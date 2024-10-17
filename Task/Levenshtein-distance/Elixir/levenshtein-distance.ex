defmodule Levenshtein do
  def distance(a, b) do
    ta = String.downcase(a) |> to_charlist |> List.to_tuple
    tb = String.downcase(b) |> to_charlist |> List.to_tuple
    m = tuple_size(ta)
    n = tuple_size(tb)
    costs = Enum.reduce(0..m, %{},   fn i,acc -> Map.put(acc, {i,0}, i) end)
    costs = Enum.reduce(0..n, costs, fn j,acc -> Map.put(acc, {0,j}, j) end)
    Enum.reduce(0..n-1, costs, fn j, acc ->
      Enum.reduce(0..m-1, acc, fn i, map ->
        d = if elem(ta, i) == elem(tb, j) do
              map[ {i,j} ]
            else
              Enum.min([ map[ {i  , j+1} ] + 1,         # deletion
                         map[ {i+1, j  } ] + 1,         # insertion
                         map[ {i  , j  } ] + 1 ])       # substitution
            end
        Map.put(map, {i+1, j+1}, d)
      end)
    end)
    |> Map.get({m,n})
  end
end

words = ~w(kitten sitting saturday sunday rosettacode raisethysword)
Enum.each(Enum.chunk(words, 2), fn [a,b] ->
  IO.puts "distance(#{a}, #{b}) = #{Levenshtein.distance(a,b)}"
end)
