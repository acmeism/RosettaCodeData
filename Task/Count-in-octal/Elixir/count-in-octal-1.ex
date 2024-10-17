Stream.iterate(0,&(&1+1)) |> Enum.each(&IO.puts Integer.to_string(&1,8))
