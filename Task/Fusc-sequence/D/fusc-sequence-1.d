import std.functional, std.stdio, std.format, std.conv;

ulong fusc(ulong n) =>
  memoize!fuscImp(n);

ulong fuscImp(ulong n) =>
  ( n < 2 ) ? n :
  ( n % 2 == 0 ) ? memoize!fuscImp( n/2 ) :
  memoize!fuscImp( (n-1)/2 ) + memoize!fuscImp( (n+1)/2 );

void main() {
  const N_FIRST=61;
  const MAX_N_DIGITS=5;

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
