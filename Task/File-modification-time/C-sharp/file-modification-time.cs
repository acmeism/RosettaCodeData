using System;
using System.IO;

Console.WriteLine(File.GetLastWriteTime("file.txt"));
File.SetLastWriteTime("file.txt", DateTime.Now);
