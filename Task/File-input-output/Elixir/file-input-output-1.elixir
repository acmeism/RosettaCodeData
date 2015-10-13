defmodule FileReadWrite do
  def copy(path,new_path) do
    case File.read(path) do
      # In case of success, write to the new file
      {:ok, body} ->
        # Can replace with :write! to generate an error upon failure
        File.write(new_path,body)
      # If not successful, raise an error
      {:error,reason} ->
        # Using Erlang's format_error to generate error string
        :file.format_error(reason)
    end
  end
end

FileReadWrite.copy("input.txt","output.txt")
