import std.stdio;
import std.file;
import std.path;

void main(string[] args) {
  auto path = args.length > 1 ? args[1] : "." ; // default current
  auto pattern = args.length > 2 ? args[2] : "*.*"; // default all file

  bool matchNPrint(DirEntry* de){
    if(!de.isdir && fnmatch(de.name, pattern))
      writefln(de.name) ;
    return true ; // continue
  }

  listdir(path, &matchNPrint) ;
}
