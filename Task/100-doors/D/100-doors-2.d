import std.stdio;
const N = 101; // #doors + 1
void main() {
  for( auto door=1,s=3; door<N; door+=s, s+=2 )
    write(door, " ");
}
