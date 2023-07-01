defmodule Fork do
  def start do
    spawn(fn -> child end)
    IO.puts "This is the original process"
  end

  def child, do: IO.puts "This is the new process"
end

Fork.start
