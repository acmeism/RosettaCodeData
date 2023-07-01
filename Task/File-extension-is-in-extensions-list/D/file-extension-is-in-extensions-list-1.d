import std.stdio;
import std.string;
import std.range;
import std.algorithm;

void main()
{
  auto exts = ["zip", "rar", "7z", "gz", "archive", "A##"];
  auto filenames = ["MyData.a##",
                    "MyData.tar.Gz",
                    "MyData.gzip",
                    "MyData.7z.backup",
                    "MyData...",
                    "MyData"];

  writeln("extensions: ", exts);
  writeln;

  foreach(filename; filenames)
  {
    string extension = filename.drop(filename.lastIndexOf(".") + 1).toLower;

    bool found;
    foreach(ext; exts)
    {
      if (extension == ext.toLower)
      {
        found = true;
        break;
      }
    }

    writeln(filename, " : ", found);
  }
