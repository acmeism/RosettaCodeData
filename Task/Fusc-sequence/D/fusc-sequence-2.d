import std.stdio, std.format, std.conv;

int[] fusc_cache = [0, 1];
int fusc(int n) {
  // Ensure cache contains all missing numbers until n
  for(auto i=fusc_cache.length;i<=n;i++)
    fusc_cache ~= i%2 == 0
      ? fusc_cache[i/2]
      : fusc_cache[(i-1)/2] + fusc_cache[(i + 1)/2];
  // Solve using cache
  return fusc_cache[n];
}

void main() {
  const N_FIRST=61;
  const MAX_N_DIGITS=6;

  format!"First %d fusc numbers: "(N_FIRST).write;
  foreach( n; 0..N_FIRST ) n.fusc.format!"%d ".write;
  writeln;

  format!"\nFusc numbers with more digits than any previous (1 to %d digits):"(MAX_N_DIGITS).writeln;
  for(auto n=0, ndigits=0; ndigits<MAX_N_DIGITS; n++)
    if( n.fusc.to!string.length > ndigits ){
      format!"fusc(%d)=%d"( n, n.fusc ).writeln;
      ndigits = n.fusc.to!string.length.to!int;
    }
}
