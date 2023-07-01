split = fn str ->
          IO.puts " input string: #{str}"
          String.graphemes(str)
          |> Enum.chunk_by(&(&1))
          |> Enum.map_join(", ", &Enum.join &1)
          |> fn s -> IO.puts "output string: #{s}" end.()
        end

split.("gHHH5YY++///\\")
