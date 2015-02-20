import std.stdio, std.algorithm;

void heapSort(R)(R seq) pure nothrow @safe @nogc {
   static void siftDown(R seq, in size_t start,
                        in size_t end) pure nothrow @safe @nogc {
      for (size_t root = start; root * 2 + 1 <= end; ) {
         auto child = root * 2 + 1;
         if (child + 1 <= end && seq[child] < seq[child + 1])
            child++;
         if (seq[root] < seq[child]) {
            swap(seq[root], seq[child]);
            root = child;
         } else
            break;
      }
   }

   if (seq.length > 1)
      foreach_reverse (immutable start; 1 .. (seq.length - 2) / 2 + 2)
         siftDown(seq, start - 1, seq.length - 1);

   foreach_reverse (immutable end; 1 .. seq.length) {
      swap(seq[end], seq[0]);
      siftDown(seq, 0, end - 1);
   }
}

void main() {
   auto data = [7, 6, 5, 9, 8, 4, 3, 1, 2, 0];
   data.heapSort;
   data.writeln;
}
