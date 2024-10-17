defmodule FileReader do
  # Read in the file
  def read(path) do
    case File.read(path) do
      {:ok, body} ->
        IO.inspect body
      {:error,reason} ->
        :file.format_error(reason)
      end
    end

  # Open the file path, then read in the file
  def bit_read(path) do
    case File.open(path) do
      {:ok, file} ->
        # :all can be replaced with :line, or with a positive integer to specify the number of characters to read.
	IO.read(file,:all)
	  |> IO.inspect
      {:error,reason} ->
	:file.format_error(reason)
    end
  end
end
