program CollatzSelf;
uses
  sysutils;
var
  n,c,One : Uint64;
  count: Int32;

function Solution(n,c:Uint64):boolean;
begin
  writeln(Format('%d x %d = %d',[n,c div n,c]));
  inc(count);
  Solution := count = 7;
end;

begin
  writeln('selfcontained numbers of collatz sequence');
  count := 0;
  n := 3; // always odd > 1
  One := 1;
  repeat
    c := n;

    repeat
      //grow and make even
      c := 3*c+One;
      //is selfcontained then
      if c Mod n = 0 then
        BREAK;
      //reduce to odd
      repeat
        c := c SHR 1;
      until c AND One <> 0;
    until c = One;

    if c <> one then
      if Solution(n,c)  then
        BREAK;

    n += 2;
  until false;
end.
