import std.stdio;
import std.file;
import std.regexp;

void main(string[] args) {
  auto path = args.length > 1 ? args[1] : "." ; // default current
  auto pattern = args.length > 2 ? args[2] : "*.*"; // default all file 		
  bool useRegExp = (args.length > 3 && args[3] == "-re") ; // pattern matching method

  if (args.length > 3 && args[3] == "-re")
    // use Regular Expression
    foreach (d; listdir(path, RegExp(pattern)))
      writefln(d);
  else
   // use unix shell style	pattern matching
   foreach (d; listdir(path, pattern))
     writefln(d);							
 }
