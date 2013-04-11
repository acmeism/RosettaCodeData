import std.stdio;
import std.file;
import std.regexp;
import std.path ;

void main(string[] args) {
  auto path = args.length > 1 ? args[1] : "." ; // default current
  auto pattern = args.length > 2 ? args[2] : "*.*"; // default all file
  bool useRegExp = (args.length > 3 && args[3] == "-re") ; // pattern matching method
  bool recursive = (args.length <= 4 || args[4] != "-nr") ; // recursive?

  bool matchNPrint(DirEntry* de) {
    bool bPrint = false ;
    if(!de.isdir) {
      if(useRegExp){
        if(search(de.name, pattern)) // this _search_ from regexp module
          writefln(de.name) ;
      }else{
        if(fnmatch(de.name, pattern)) // this _fnmatch_ from path module
          writefln(de.name) ;
      }
    } else
      if(recursive)
        listdir(de.name, &matchNPrint) ; // recursive sub dir
    return true ; // continue
  }

  listdir(path, &matchNPrint) ;
}
