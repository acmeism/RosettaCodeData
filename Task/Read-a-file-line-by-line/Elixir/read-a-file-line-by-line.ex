  defmodule FileReader do
    # Create a File.Stream and inspect each line
    def by_line(path) do
      File.stream!(path)
        |> Stream.map(&(IO.inspect(&1)))
	|> Stream.run
      end

    def bin_line(path) do
    # Build the stream in binary instead for performance increase
      case File.open(path) do
        # File returns a tuple, {:ok,file}, if successful
        {:ok, file} ->
	  IO.binstream(file, :line)
	    |> Stream.map(&(IO.inspect(&1)))
	    |> Stream.run
	# And returns {:error,reason} if unsuccessful
	{:error,reason} ->
	# Use Erlang's format_error to return an error string
	  :file.format_error(reason)
      end
    end
  end
