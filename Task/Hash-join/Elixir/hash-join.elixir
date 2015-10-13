defmodule Hash do
  def join(table1, index1, table2, index2) do
    h = Enum.group_by(table1, fn s -> elem(s, index1) end)
    Enum.flat_map(table2, fn r ->
      Enum.map(h[elem(r, index2)], fn s -> {s, r} end)
    end)
  end
end

table1 = [{27, "Jonah"},
          {18, "Alan"},
          {28, "Glory"},
          {18, "Popeye"},
          {28, "Alan"}]
table2 = [{"Jonah", "Whales"},
          {"Jonah", "Spiders"},
          {"Alan",  "Ghosts"},
          {"Alan",  "Zombies"},
          {"Glory", "Buffy"}]
Hash.join(table1, 1, table2, 0) |> Enum.each(&IO.inspect &1)
