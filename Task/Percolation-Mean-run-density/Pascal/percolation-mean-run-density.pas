{$MODE objFPC}//for using result,parameter runs becomes for variable..
uses
  sysutils;//Format
const
  MaxN = 100*1000;

function run_test(p:double;len,runs: NativeInt):double;
var
   x, y, i,cnt : NativeInt;
Begin
  result := 1/ (runs * len);
  cnt := 0;
  for  runs := runs-1 downto 0 do
  Begin
    x := 0;
    y := 0;
    for i := len-1 downto 0 do
    begin
      x := y;
      y := Ord(Random() < p);
      cnt := cnt+ord(x < y);
    end;
  end;
  result := result *cnt;
end;

//main
var
  p, p1p, K : double;
  ip, n : nativeInt;
Begin
  randomize;
  writeln( 'running 1000 tests each:'#13#10,
    ' p      n      K     p(1-p)   diff'#13#10,
    '-----------------------------------------------');
  ip:= 1;
  while ip < 10 do
  Begin
     p := ip / 10;
     p1p := p * (1 - p);
     n := 100;
     While n <= MaxN do
     Begin
       K := run_test(p, n, 1000);
       writeln(Format('%4.1f %6d  %6.4f  %6.4f %7.4f (%5.2f %%)',
         [p, n, K, p1p, K - p1p, (K - p1p) / p1p * 100]));
       n := n*10;
     end;
     writeln;
     ip := ip+2;
   end;
end.
