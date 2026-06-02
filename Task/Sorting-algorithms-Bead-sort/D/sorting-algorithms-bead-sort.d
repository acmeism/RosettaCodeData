import std.stdio, std.algorithm, std.range;

auto beadSort(int[] l) pure /*nothrow @nogc*/ {
   auto columns(R)(R m) pure /*nothrow*/ @safe /*@nogc*/ {
       int[][] r;
       foreach (i; 0 .. reduce!max(map!walkLength(m))) {
           r.length += 1;
           foreach (sub; m)
               if (sub.length > i)
                   r[$-1] ~= 0;
       }
       return r;
   }
   auto m = map!"new int[a]"(l);
   return map!walkLength(columns(columns(m)));
}

void main() {
   writeln(beadSort([5, 3, 1, 7, 4, 1, 1]));
}
