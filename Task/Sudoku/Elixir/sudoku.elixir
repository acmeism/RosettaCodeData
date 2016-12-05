defmodule Sudoku do
  def display( grid ), do: ( for y <- 1..9, do: display_row(y, grid) )

  def start( knowns ), do: Enum.into( knowns, Map.new )

  def solve( grid ) do
    sure = solve_all_sure( grid )
    solve_unsure( potentials(sure), sure )
  end

  def task( knowns ) do
    IO.puts "start"
    start = start( knowns )
    display( start )
    IO.puts "solved"
    solved = solve( start )
    display( solved )
    IO.puts ""
  end

  defp bt( grid ), do: bt_reject( is_not_allowed(grid), grid )

  defp bt_accept( true, board ), do: throw( {:ok, board} )
  defp bt_accept( false, grid ), do: bt_loop( potentials_one_position(grid), grid )

  defp bt_loop( {position, values}, grid ), do: ( for x <- values, do: bt( Map.put(grid, position, x) ) )

  defp bt_reject( true, _grid ), do: :backtrack
  defp bt_reject( false, grid ), do: bt_accept( is_all_correct(grid), grid )

  defp display_row( row, grid ) do
    for x <- [1, 4, 7], do: display_row_group( x, row, grid )
    display_row_nl( row )
  end

  defp display_row_group( start, row, grid ) do
    Enum.each(start..start+2, &IO.write " #{Map.get( grid, {&1, row}, ".")}")
    IO.write " "
  end

  defp display_row_nl( n ) when n in [3,6,9], do: IO.puts "\n"
  defp display_row_nl( _n ), do: IO.puts ""

  defp is_all_correct( grid ), do: map_size( grid ) == 81

  defp is_not_allowed( grid ) do
    is_not_allowed_rows( grid ) or is_not_allowed_columns( grid ) or is_not_allowed_groups( grid )
  end

  defp is_not_allowed_columns( grid ), do: values_all_columns(grid) |> Enum.any?(&is_not_allowed_values/1)

  defp is_not_allowed_groups( grid ),  do: values_all_groups(grid)  |> Enum.any?(&is_not_allowed_values/1)

  defp is_not_allowed_rows( grid ),    do: values_all_rows(grid)    |> Enum.any?(&is_not_allowed_values/1)

  defp is_not_allowed_values( values ), do: length( values ) != length( Enum.uniq(values) )

  defp group_positions( {x, y} ) do
    for colum <- group_positions_close(x), row <- group_positions_close(y), do: {colum, row}
  end

  defp group_positions_close( n ) when n < 4, do: [1,2,3]
  defp group_positions_close( n ) when n < 7, do: [4,5,6]
  defp group_positions_close( _n )          , do: [7,8,9]

  defp positions_not_in_grid( grid ) do
    keys = Map.keys( grid )
    for x <- 1..9, y <- 1..9, not {x, y} in keys, do: {x, y}
  end

  defp potentials_one_position( grid ) do
    Enum.min_by( potentials( grid ), fn {_position, values} -> length(values) end )
  end

  defp potentials( grid ), do: List.flatten( for x <- positions_not_in_grid(grid), do: potentials(x, grid) )

  defp potentials( position, grid ) do
    useds = potentials_used_values( position, grid )
    {position, Enum.to_list(1..9) -- useds }
  end

  defp potentials_used_values( {x, y}, grid ) do
    row_values    = (for row <- 1..9, row != x, do: {row, y})          |> potentials_values( grid )
    column_values = (for column <- 1..9, column != y, do: {x, column}) |> potentials_values( grid )
    group_values  = group_positions({x, y}) -- [ {x, y} ]              |> potentials_values( grid )
    row_values ++ column_values ++ group_values
  end

  defp potentials_values( keys, grid ) do
    for x <- keys, val = grid[x], do: val
  end

  defp values_all_columns( grid ) do
    for x <- 1..9, do:
      ( for y <- 1..9, do: {x, y} ) |> potentials_values( grid )
  end

  defp values_all_groups( grid ) do
    [[g1,g2,g3], [g4,g5,g6], [g7,g8,g9]] = for x <- [1,4,7], do: values_all_groups(x, grid)
    [g1,g2,g3,g4,g5,g6,g7,g8,g9]
  end

  defp values_all_groups( x, grid ) do
    for x_offset <- x..x+2, do: values_all_groups(x, x_offset, grid)
  end

  defp values_all_groups( _x, x_offset, grid ) do
    ( for y_offset <- group_positions_close(x_offset), do: {x_offset, y_offset} )
    |> potentials_values( grid )
  end

  defp values_all_rows( grid ) do
    for y <- 1..9, do:
      ( for x <- 1..9, do: {x, y} ) |> potentials_values( grid )
  end

  defp solve_all_sure( grid ), do: solve_all_sure( solve_all_sure_values(grid), grid )

  defp solve_all_sure( [], grid ), do: grid
  defp solve_all_sure( sures, grid ) do
    solve_all_sure( Enum.reduce(sures, grid, &solve_all_sure_store/2) )
  end

  defp solve_all_sure_values( grid ), do: (for{position, [value]} <- potentials(grid), do: {position, value} )

  defp solve_all_sure_store( {position, value}, acc ), do: Map.put( acc, position, value )

  defp solve_unsure( [], grid ), do: grid
  defp solve_unsure( _potentials, grid ) do
    try do
      bt( grid )
    catch
      {:ok, board} -> board
    end
  end
end

simple = [{{1, 1}, 3}, {{2, 1}, 9}, {{3, 1},4}, {{6, 1}, 2}, {{7, 1}, 6}, {{8, 1}, 7},
          {{4, 2}, 3}, {{7, 2}, 4},
          {{1, 3}, 5}, {{4, 3}, 6}, {{5, 3}, 9}, {{8, 3}, 2},
          {{2, 4}, 4}, {{3, 4}, 5}, {{7, 4}, 9},
          {{1, 5}, 6}, {{9, 5}, 7},
          {{3, 6}, 7}, {{7, 6}, 5}, {{8, 6}, 8},
          {{2, 7}, 1}, {{5, 7}, 6}, {{6, 7}, 7}, {{9, 7}, 8},
          {{3, 8}, 9}, {{6, 8}, 8},
          {{2, 9}, 2}, {{3, 9}, 6}, {{4, 9}, 4}, {{7, 9}, 7}, {{8, 9}, 3}, {{9, 9}, 5}]
Sudoku.task( simple )

difficult = [{{6, 2}, 3}, {{8, 2}, 8}, {{9, 2}, 5},
             {{3, 3}, 1}, {{5, 3}, 2},
             {{4, 4}, 5}, {{6, 4}, 7},
             {{3, 5}, 4}, {{7, 5}, 1},
             {{2, 6}, 9},
             {{1, 7}, 5}, {{8, 7}, 7}, {{9, 7}, 3},
             {{3, 8}, 2}, {{5, 8}, 1},
             {{5, 9}, 4}, {{9, 9}, 9}]
Sudoku.task( difficult )
