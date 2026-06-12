import std.stdio;
import std.string;
import std.range;
import std.algorithm;

void main()
{
  auto filenames = ["http://example.com/download.tar.gz",
                    "CharacterModel.3DS",
                    ".desktop",
                    "document",
                    "document.txt_backup",
                    "/etc/pam.d/login"]

  foreach(filename; filenames)
  {
    string ext;
    auto idx = filename.lastIndexOf(".");
    if(idx >= 0)
    {
      auto tmp = filename.drop(idx);
      if(!tmp.canFind("/", "\\", "_", "*");
        ext = tmp;
    }
    writeln(filename, " -> ", ext);
  }

}

