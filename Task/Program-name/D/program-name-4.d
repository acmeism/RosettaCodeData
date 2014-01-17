// thisExePath function was introduced in D 2.064 (November 5, 2013)

import std.file;
import std.stdio;

void main(string[] args)
{
    writeln("Program: ", thisExePath());
}
