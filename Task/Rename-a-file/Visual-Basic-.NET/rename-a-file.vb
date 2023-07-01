'Current Directory
IO.Directory.Move("docs", "mydocs")
IO.File.Move("input.txt", "output.txt")

'Root
IO.Directory.Move("\docs", "\mydocs")
IO.File.Move("\input.txt", "\output.txt")

'Root, platform independent
IO.Directory.Move(IO.Path.DirectorySeparatorChar & "docs", _
 IO.Path.DirectorySeparatorChar & "mydocs")
IO.File.Move(IO.Path.DirectorySeparatorChar & "input.txt", _
  IO.Path.DirectorySeparatorChar & "output.txt")
