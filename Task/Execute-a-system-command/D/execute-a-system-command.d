import std.process, std.stdio;
//these two alternatives wait for the process to return, and capture the output
//each process function returns a Tuple of (int)"status" and (string)"output
auto ls_string = executeShell("ls -l"); //takes single string
writeln((ls_string.status == 0) ? ls_string.output : "command failed");

auto ls_array = execute(["ls", "-l"]); //takes array of strings
writeln((ls_array.status == 0) ? ls_array.output : "command failed");
//other alternatives exist to spawn processes in parallel and capture output via pipes
