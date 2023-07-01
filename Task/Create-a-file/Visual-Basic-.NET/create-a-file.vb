 'Current Directory
IO.Directory.CreateDirectory("docs")
IO.File.Create("output.txt").Close()

 'Root
IO.Directory.CreateDirectory("\docs")
IO.File.Create("\output.txt").Close()

 'Root, platform independent
IO.Directory.CreateDirectory(IO.Path.DirectorySeparatorChar & "docs")
IO.File.Create(IO.Path.DirectorySeparatorChar & "output.txt").Close()
