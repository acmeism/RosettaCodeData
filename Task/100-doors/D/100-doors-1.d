import std.stdio;
const N = 101; // #doors + 1
void main() {
  bool[N] doors = false;
  for(auto door=1; door<N; door++ ) {
    for(auto i=door; i<N; i+=door ) doors[i] = !doors[i];
    if (doors[door]) write(door, " ");
  }
}
