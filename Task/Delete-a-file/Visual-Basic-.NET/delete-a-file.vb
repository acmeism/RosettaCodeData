'Current Directory
IO.Directory.Delete("docs")
IO.Directory.Delete("docs", True) 'also delete files and sub-directories
IO.File.Delete("output.txt")

'Root
IO.Directory.Delete("\docs")
IO.File.Delete("\output.txt")

'Root, platform independent
IO.Directory.Delete(IO.Path.DirectorySeparatorChar & "docs")
IO.File.Delete(IO.Path.DirectorySeparatorChar & "output.txt")
