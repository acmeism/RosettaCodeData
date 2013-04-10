import std.stdio ;

void main(string[] args) {
  foreach(i, e ; args[1..$])
    writefln("#%2d : %s", i + 1, e) ;
}
