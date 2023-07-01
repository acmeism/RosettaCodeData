import std.stdio;

void printAllDoors(bool[] doors)
{
   // Prints the state of all the doors
   foreach(i, door; doors)
   {
      writeln("#: ", i + 1, (door) ? " open" : " closed");
      }
}
void main()
{
   bool[100] doors = false;   //Create 100 closed doors
   for(int a = 0; a < 100; ++a) {
      writefln("Pass #%s; visiting every %s door.", a + 1, a + 1);  // Optional
	 for(int i = a; i < 100; i += (a + 1)) {
	 writefln("Visited door %s", i + 1);  //Optional
	 doors[i] = !doors[i];
	 }
      writeln();  // Optional
      }
   printAllDoors(doors);   // Prints the state of each door
}
