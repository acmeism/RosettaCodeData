sleep = fn seconds ->
          IO.puts "Sleeping..."
          :timer.sleep(1000 * seconds)    #  in milliseconds
          IO.puts "Awake!"
        end

sec = if System.argv==[], do: 1, else: hd(System.argv) |> String.to_integer
sleep.(sec)
