defmodule Optional_parameters do
  def sort( table, options\\[] ) do
    options = options ++ [ ordering: :lexicographic, column: 0, reverse: false ]
    ordering = options[ :ordering ]
    column   = options[ :column ]
    reverse  = options[ :reverse ]
    sorted = sort( table, ordering, column )
    if reverse, do: Enum.reverse( sorted ), else: sorted
  end

  defp sort( table, :lexicographic, column ) do
    Enum.sort_by( table, &elem( &1, column ) )
  end
  defp sort( table, :numeric, column ) do
    Enum.sort_by( table, &elem( &1, column ) |> String.to_integer )
  end

  def task do
    table = [ { "123", "456", "0789" },
              { "456", "0789", "123" },
              { "0789", "123", "456" } ]
    IO.write "sort defaults "; IO.inspect sort( table )
    IO.write " & reverse    "; IO.inspect sort( table, reverse: true )
    IO.write "sort column 2 "; IO.inspect sort( table, column: 2)
    IO.write " & reverse    "; IO.inspect sort( table, column: 2, reverse: true)
    IO.write "sort numeric  "; IO.inspect sort( table, ordering: :numeric)
    IO.write " & reverse    "; IO.inspect sort( table, ordering: :numeric, reverse: true)
  end
end

Optional_parameters.task
