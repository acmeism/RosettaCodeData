path = hd(System.argv)
IO.puts File.dir?(path) and Enum.empty?( File.ls!(path) )
