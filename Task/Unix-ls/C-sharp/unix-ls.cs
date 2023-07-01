using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Unix_ls
{
    public class UnixLS
    {
        public static void Main(string[] args)
        {
            UnixLS ls = new UnixLS();
            ls.list(args.Length.Equals(0) ? "." : args[0]);
        }

        private void list(string folder)
        {
            foreach (FileSystemInfo fileSystemInfo in new DirectoryInfo(folder).EnumerateFileSystemInfos("*", SearchOption.TopDirectoryOnly))
            {
                Console.WriteLine(fileSystemInfo.Name);
            }
        }
    }
}
