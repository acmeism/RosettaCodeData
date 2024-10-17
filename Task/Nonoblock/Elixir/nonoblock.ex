defmodule Nonoblock do
  def solve(cell, blocks) do
    width = Enum.sum(blocks) + length(blocks) - 1
    if cell < width do
      raise "Those blocks will not fit in those cells"
    else
      nblocks(cell, blocks, "")
    end
  end

  defp nblocks(cell, _, position) when cell<=0, do:
    display(String.slice(position, 0..cell-1))
  defp nblocks(cell, blocks, position) when length(blocks)==0 or hd(blocks)==0, do:
    display(position <> String.duplicate(".", cell))
  defp nblocks(cell, blocks, position) do
    rest = cell - Enum.sum(blocks) - length(blocks) + 2
    [bl | brest] = blocks
    Enum.reduce(0..rest-1, 0, fn i,acc ->
      acc + nblocks(cell-i-bl-1, brest, position <> String.duplicate(".", i) <> String.duplicate("#",bl) <> ".")
    end)
  end

  defp display(str) do
    IO.puts nonocell(str)
    1                           # number of positions
  end

  def nonocell(str) do                  # "##.###..##" -> "|A|A|_|B|B|B|_|_|C|C|"
    slist = String.to_char_list(str) |> Enum.chunk_by(&(&1==?.)) |> Enum.map(&List.to_string(&1))
    chrs = Enum.map(?A..?Z, &List.to_string([&1]))
    result = nonocell_replace(slist, chrs, "")
             |> String.replace(".", "_")
             |> String.split("") |> Enum.join("|")
    "|" <> result
  end

  defp nonocell_replace([], _, result), do: result
  defp nonocell_replace([h|t], chrs, result) do
    if String.first(h) == "#" do
      [c | rest] = chrs
      nonocell_replace(t, rest, result <> String.replace(h, "#", c))
    else
      nonocell_replace(t, chrs, result <> h)
    end
  end
end

conf = [{ 5, [2, 1]},
        { 5, []},
        {10, [8]},
        {15, [2, 3, 2, 3]},
        { 5, [2, 3]}       ]
Enum.each(conf, fn {cell, blocks} ->
  try do
    IO.puts "Configuration:"
    IO.puts "#{Nonoblock.nonocell(String.duplicate(".",cell))} # #{cell} cells and #{inspect blocks} blocks"
    IO.puts "Possibilities:"
    count = Nonoblock.solve(cell, blocks)
    IO.puts "A total of #{count} Possible configurations.\n"
  rescue
    e in RuntimeError -> IO.inspect e
  end
end)
