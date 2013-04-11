import std.stdio, std.traits;

void main() {
   enum width = 75, height = 52;
   enum maxSteps = 12_000;
   enum Direction { up, right, down, left }
   enum Color : char { white = '.', black = '#' }
   uint x = width / 2, y = height / 2;
   auto M = new Color[][](height, width);
   auto dir = Direction.up;

   for (int i = 0; i < maxSteps && x < width && y < height; i++) {
      immutable turn = M[y][x] == Color.black;
      dir = [EnumMembers!Direction][(dir + (turn ? 1 : -1)) & 3];
      M[y][x] = (M[y][x] == Color.black) ? Color.white : Color.black;
      final switch(dir) with (Direction) {
         case up:    y--; break;
         case right: x--; break;
         case down:  y++; break;
         case left:  x++; break;
      }
   }

   writefln("%-(%s\n%)", cast(char[][])M);
}
