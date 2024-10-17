defmodule ZebraPuzzle do
  defp adjacent?(n,i,g,e) do
    Enum.any?(0..3, fn x ->
      (Enum.at(n,x)==i and Enum.at(g,x+1)==e) or (Enum.at(n,x+1)==i and Enum.at(g,x)==e)
    end)
  end

  defp leftof?(n,i,g,e) do
    Enum.any?(0..3, fn x -> Enum.at(n,x)==i and Enum.at(g,x+1)==e end)
  end

  defp coincident?(n,i,g,e) do
    Enum.with_index(n) |> Enum.any?(fn {x,idx} -> x==i and Enum.at(g,idx)==e end)
  end

  def solve(content) do
    colours = permutation(content[:Colour])
    pets    = permutation(content[:Pet])
    drinks  = permutation(content[:Drink])
    smokes  = permutation(content[:Smoke])
    Enum.each(permutation(content[:Nationality]), fn nation ->
      if hd(nation) == :Norwegian, do:                                      # 10
        Enum.each(colours, fn colour ->
          if leftof?(colour, :Green, colour, :White)      and               # 5
             coincident?(nation, :English, colour, :Red)  and               # 2
             adjacent?(nation, :Norwegian, colour, :Blue), do:              # 15
            Enum.each(pets, fn pet ->
              if coincident?(nation, :Swedish, pet, :Dog), do:              # 3
                Enum.each(drinks, fn drink ->
                  if Enum.at(drink,2) == :Milk                   and        # 9
                     coincident?(nation, :Danish, drink, :Tea)   and        # 4
                     coincident?(colour, :Green, drink, :Coffee), do:       # 6
                    Enum.each(smokes, fn smoke ->
                      if coincident?(smoke, :PallMall, pet, :Birds)    and  # 7
                         coincident?(smoke, :Dunhill, colour, :Yellow) and  # 8
                         coincident?(smoke, :BlueMaster, drink, :Beer) and  # 13
                         coincident?(smoke, :Prince, nation, :German)  and  # 14
                         adjacent?(smoke, :Blend, pet, :Cats)          and  # 11
                         adjacent?(smoke, :Blend, drink, :Water)       and  # 16
                         adjacent?(smoke, :Dunhill, pet, :Horse), do:       # 12
                        print_out(content, transpose([nation, colour, pet, drink, smoke]))
    end)end)end)end)end)
  end

  defp permutation([]), do: [[]]
  defp permutation(list) do
    for x <- list, y <- permutation(list -- [x]), do: [x|y]
  end

  defp transpose(lists) do
    List.zip(lists) |> Enum.map(&Tuple.to_list/1)
  end

  defp print_out(content, result) do
    width = for {k,v}<-content, do: Enum.map([k|v], &length(to_char_list &1)) |> Enum.max
    fmt = Enum.map_join(width, " ", fn w -> "~-#{w}s" end) <> "~n"
    nation = Enum.find(result, fn x -> :Zebra in x end) |> hd
    IO.puts "The Zebra is owned by the man who is #{nation}\n"
    :io.format fmt, Keyword.keys(content)
    :io.format fmt, Enum.map(width, fn w -> String.duplicate("-", w) end)
    fmt2 = String.replace(fmt, "s", "w", global: false)
    Enum.with_index(result)
    |> Enum.each(fn {x,i} -> :io.format fmt2, [i+1 | x] end)
  end
end

content = [ House:       '',
            Nationality: ~w[English Swedish Danish Norwegian German]a,
            Colour:      ~w[Red Green White Blue Yellow]a,
            Pet:         ~w[Dog Birds Cats Horse Zebra]a,
            Drink:       ~w[Tea Coffee Milk Beer Water]a,
            Smoke:       ~w[PallMall Dunhill BlueMaster Prince Blend]a ]

ZebraPuzzle.solve(content)
