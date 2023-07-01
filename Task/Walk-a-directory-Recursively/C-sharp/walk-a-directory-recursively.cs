using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace RosettaRecursiveDirectory
{
    class Program
    {
        static IEnumerable<FileInfo> TraverseDirectory(string rootPath, Func<FileInfo, bool> Pattern)
        {
            var directoryStack = new Stack<DirectoryInfo>();
            directoryStack.Push(new DirectoryInfo(rootPath));
            while (directoryStack.Count > 0)
            {
                var dir = directoryStack.Pop();
                try
                {
                    foreach (var i in dir.GetDirectories())
                        directoryStack.Push(i);
                }
                catch (UnauthorizedAccessException) {
                    continue; // We don't have access to this directory, so skip it
                }
                foreach (var f in dir.GetFiles().Where(Pattern)) // "Pattern" is a function
                    yield return f;
            }
        }
        static void Main(string[] args)
        {
            // Print the full path of all .wmv files that are somewhere in the C:\Windows directory or its subdirectories
            foreach (var file in TraverseDirectory(@"C:\Windows", f => f.Extension == ".wmv"))
                Console.WriteLine(file.FullName);
            Console.WriteLine("Done.");
        }
    }
}
