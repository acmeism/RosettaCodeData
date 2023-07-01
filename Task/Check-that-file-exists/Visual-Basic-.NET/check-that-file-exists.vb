'Current Directory
Console.WriteLine(If(IO.Directory.Exists("docs"), "directory exists", "directory doesn't exists"))
Console.WriteLine(If(IO.Directory.Exists("output.txt"), "file exists", "file doesn't exists"))

'Root
Console.WriteLine(If(IO.Directory.Exists("\docs"), "directory exists", "directory doesn't exists"))
Console.WriteLine(If(IO.Directory.Exists("\output.txt"), "file exists", "file doesn't exists"))

'Root, platform independent
Console.WriteLine(If(IO.Directory.Exists(IO.Path.DirectorySeparatorChar & "docs"), _
   "directory exists", "directory doesn't exists"))
Console.WriteLine(If(IO.Directory.Exists(IO.Path.DirectorySeparatorChar & "output.txt"), _
  "file exists", "file doesn't exists"))
