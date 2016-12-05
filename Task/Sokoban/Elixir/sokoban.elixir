defmodule Sokoban do
  defp setup(level) do
    {leng, board} = normalize(level)
    {player, goal} = check_position(board)
    board = replace(board, [{".", " "}, {"+", " "}, {"*", "$"}])
    lurd = [{-1, "l", "L"}, {-leng, "u", "U"}, {1, "r", "R"}, {leng, "d", "D"}]
    dirs = [-1, -leng, 1, leng]
    dead_zone = set_dead_zone(board, goal, dirs)
    {board, player, goal, lurd, dead_zone}
  end

  defp normalize(level) do
    board = String.split(level, "\n", trim: true)
            |> Enum.map(&String.trim_trailing &1)
    leng  = Enum.map(board, &String.length &1) |> Enum.max
    board = Enum.map(board, &String.pad_trailing(&1, leng)) |> Enum.join
    {leng, board}
  end

  defp check_position(board) do
    board = String.codepoints(board)
    player = Enum.find_index(board, fn c -> c in ["@", "+"] end)
    goal = Enum.with_index(board)
           |> Enum.filter_map(fn {c,_} -> c in [".", "+", "*"] end, fn {_,i} -> i end)
    {player, goal}
  end

  defp set_dead_zone(board, goal, dirs) do
    wall = String.replace(board, ~r/[^#]/, " ")
           |> String.codepoints
           |> Enum.with_index
           |> Enum.into(Map.new, fn {c,i} -> {i,c} end)
    corner = search_corner(wall, goal, dirs)
    set_dead_zone(wall, dirs, goal, corner, corner)
  end

  defp set_dead_zone(wall, dirs, goal, corner, dead) do
    dead2 = Enum.reduce(corner, dead, fn pos,acc ->
              Enum.reduce(dirs, acc, fn dir,acc2 ->
                if wall[pos+dir] == "#", do: acc2,
                    else: acc2 ++ check_side(wall, dirs, pos+dir, dir, goal, dead, [])
              end)
            end)
    if dead == dead2, do: :lists.usort(dead),
                    else: set_dead_zone(wall, dirs, goal, corner, dead2)
  end

  defp replace(string, replacement) do
    Enum.reduce(replacement, string, fn {a,b},str ->
      String.replace(str, a, b)
    end)
  end

  defp search_corner(wall, goal, dirs) do
    Enum.reduce(wall, [], fn {i,c},corner ->
      if c == "#" or i in goal do
        corner
      else
        case count_wall(wall, i, dirs) do
          2 -> if wall[i-1] != wall[i+1], do: [i | corner], else: corner
          3 -> [i | corner]
          _ -> corner
        end
      end
    end)
  end

  defp check_side(wall, dirs, pos, dir, goal, dead, acc) do
    if wall[pos] == "#" or
      count_wall(wall, pos, dirs) == 0 or
      pos in goal do
      []
    else
      if pos in dead, do: acc, else: check_side(wall, dirs, pos+dir, dir, goal, dead, [pos|acc])
    end
  end

  defp count_wall(wall, pos, dirs) do
    Enum.count(dirs, fn dir -> wall[pos + dir] == "#" end)
  end

  defp push_box(board, pos, dir, route, goal, dead_zone) do
    pos2dir = pos + 2 * dir
    if String.at(board, pos2dir) == " " and not pos2dir in dead_zone do
      board2 = board |> replace_at(pos,     " ")
                     |> replace_at(pos+dir, "@")
                     |> replace_at(pos2dir, "$")
      unless visited?(board2) do
        if solved?(board2, goal) do
          IO.puts route
          exit(:normal)
        else
          queue_in({board2, pos+dir, route})
        end
      end
    end
  end

  defp move_player(board, pos, dir) do
    board |> replace_at(pos, " ") |> replace_at(pos+dir, "@")
  end

  defp replace_at(str, pos, c) do
    {left, right} = String.split_at(str, pos)
    {_, right} = String.split_at(right, 1)
    left <> c <> right
    # String.slice(str, 0, pos) <> c <> String.slice(str, pos+1..-1)
  end

  defp solved?(board, goal) do
    Enum.all?(goal, fn g -> String.at(board, g) == "$" end)
  end

  @pattern :sokoban_pattern_set
  @queue   :sokoban_queue

  defp start_link do
    Agent.start_link(fn -> MapSet.new end, name: @pattern)
    Agent.start_link(fn -> :queue.new end, name: @queue)
  end

  defp visited?(board) do
    Agent.get_and_update(@pattern, fn set ->
      {board in set, MapSet.put(set, board)}
    end)
  end

  defp queue_in(data) do
    Agent.update(@queue, fn queue -> :queue.in(data, queue) end)
  end

  defp queue_out do
    Agent.get_and_update(@queue, fn q ->
      case :queue.out(q) do
        {{:value, data}, queue} -> {data, queue}
        x -> x
      end
    end)
  end

  def solve(level) do
    {board, player, goal, lurd, dead_zone} = setup(level)
    start_link
    visited?(board)
    queue_in({board, player, ""})
    solve(goal, lurd, dead_zone)
  end

  defp solve(goal, lurd, dead_zone) do
    case queue_out do
      {board, pos, route} ->
        Enum.each(lurd, fn {dir,move,push} ->
          case String.at(board, pos+dir) do
            "$" -> push_box(board, pos, dir, route<>push, goal, dead_zone)
            " " -> board2 = move_player(board, pos, dir)
                   unless visited?(board2) do
                     queue_in({board2, pos+dir, route<>move})
                   end
            _ -> :not_move    # wall
          end
        end)
      _ ->
        IO.puts "No solution"
        exit(:normal)
    end
    solve(goal, lurd, dead_zone)
  end
end

level = """
#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######
"""
IO.puts level
Sokoban.solve(level)
