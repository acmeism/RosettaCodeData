defmodule RC do
  def input_loop(stream) do
    case IO.read(stream, :line) do
      :eof -> :ok
      data -> IO.write data
              input_loop(stream)
    end
  end
end

path = hd(System.argv)
File.open!(path, [:read], fn stream -> RC.input_loop(stream) end)
