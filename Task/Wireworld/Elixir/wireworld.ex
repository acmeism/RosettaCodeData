defmodule Wireworld do
  @empty      " "
  @head       "H"
  @tail       "t"
  @conductor  "."
  @neighbours (for x<- -1..1, y <- -1..1, do: {x,y}) -- [{0,0}]

  def set_up(string) do
    lines = String.split(string, "\n", trim: true)
    grid = Enum.with_index(lines)
           |> Enum.flat_map(fn {line,i} ->
                String.codepoints(line)
                |> Enum.with_index
                |> Enum.map(fn {char,j} -> {{i, j}, char} end)
              end)
           |> Enum.into(Map.new)
    width = Enum.map(lines, fn line -> String.length(line) end) |> Enum.max
    height = length(lines)
    {grid, width, height}
  end

  # to string
  defp to_s(grid, width, height) do
    Enum.map_join(0..height-1, fn i ->
      Enum.map_join(0..width-1, fn j -> Map.get(grid, {i,j}, @empty) end) <> "\n"
    end)
  end

  # transition all cells simultaneously
  defp transition(grid) do
    Enum.into(grid, Map.new, fn {{x, y}, state} ->
      {{x, y}, transition_cell(grid, state, x, y)}
    end)
  end

  # how to transition a single cell
  defp transition_cell(grid, current, x, y) do
    case current do
      @empty -> @empty
      @head  -> @tail
      @tail  -> @conductor
      _      -> if neighbours_with_state(grid, x, y) in 1..2, do: @head, else: @conductor
    end
  end

  # given a position in the grid, find the neighbour cells with a particular state
  def neighbours_with_state(grid, x, y) do
    Enum.count(@neighbours, fn {dx,dy} -> Map.get(grid, {x+dx, y+dy}) == @head end)
  end

  # run a simulation up to a limit of transitions, or until a recurring
  # pattern is found
  # This will print text to the console
  def run(string, iterations\\25) do
    {grid, width, height} = set_up(string)
    Enum.reduce(0..iterations, {grid, %{}}, fn count,{grd, seen} ->
      IO.puts "Generation : #{count}"
      IO.puts to_s(grd, width, height)

      if seen[grd] do
        IO.puts "I've seen this grid before... after #{count} iterations"
        exit(:normal)
      else
        {transition(grd), Map.put(seen, grd, count)}
      end
    end)
    IO.puts "ran through #{iterations} iterations"
  end
end

# this is the "2 Clock generators and an XOR gate" example from the wikipedia page
text = """
 ......tH
.        ......
 ...Ht...      .
              ....
              .  .....
              ....
 tH......      .
.        ......
 ...Ht...
"""

Wireworld.run(text)
