void main() {
   import std.stdio, std.algorithm;

   enum nGenerations = 10;
   enum initial = "0011101101010101001000";
   enum table = "00010110";

   char[initial.length + 2] A = '0', B = '0';
   A[1 .. $-1] = initial;
   foreach (immutable _; 0 .. nGenerations) {
      foreach (immutable i; 1 .. A.length - 1) {
         write(A[i] == '0' ? '_' : '#');
         const val = (A[i-1]-'0' << 2) | (A[i]-'0' << 1) | (A[i+1]-'0');
         B[i] = table[val];
      }
      A.swap(B);
      writeln;
   }
}
