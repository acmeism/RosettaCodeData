import std.stdio;
import std.path;

void main()
{
  auto filenames = ["http://example.com/download.tar.gz",
                    "CharacterModel.3DS",
                    ".desktop",
                    "document",
                    "document.txt_backup",
                    "/etc/pam.d/login"]

  foreach(filename; filenames)
    writeln(filename, " -> ", filename.extension);

}
