defmodule RC do
  def start do
     my_pid = self
     pid = spawn( fn -> reader(my_pid, 0) end )
     File.open( "input.txt", [:read], fn io ->
       process( IO.gets(io, ""), io, pid )
     end )
  end

  defp process( :eof, _io, pid ) do
    send( pid, :count )
    receive do
      i -> IO.puts "Count:#{i}"
    end
  end
  defp process( any, io, pid ) do
    send( pid, any )
    process( IO.gets(io, ""), io, pid )
  end

  defp reader( pid, c ) do
    receive do
      :count -> send( pid, c )
      any ->
        IO.write any
        reader( pid, c+1 )
    end
  end
end

RC.start
