import std.stdio;
import std.string;
import std.range;
import std.algorithm;

void main()
{
  auto exts = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"];
  auto filenames = ["MyData.a##",
                    "MyData.tar.Gz",
                    "MyData.gzip",
                    "MyData.7z.backup",
                    "MyData...",
                    "MyData",
                    "MyData_v1.0.tar.bz2",
                    "MyData_v1.0.bz2"];

  writeln("extensions: ", exts);

  writeln;
  foreach(filename; filenames)
  {
    bool found;
    foreach(ext; exts)
    {
      if (filename.toLower.endsWith("." ~ ext.toLower))
      {
        found = true;
        break;
      }
    }

    writeln(filename, " : ", found);
  }

}
