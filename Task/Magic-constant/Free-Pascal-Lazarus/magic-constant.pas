program MagicConst;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}

function MagicSum(n :Uint32):Uint64; inline;
var
  k : Uint64;
begin
  k := n*Uint64(n);
  result := (k*k+k) DIV 2;
end;

function MagSumPerRow(n:Uint32):Uint32;
begin
//result := MagicSum(n) DIV n;
  //(n^3 + n) /2
  result := ((Uint64(n)*n+1)*n) DIV 2;
end;
var
  s : String[31];
  i : Uint32;
  lmt,rowcnt : extended;
Begin
  writeln('First Magic constants 3..20');
  For i := 3 to 20 do
     write(MagSumPerRow(i),' ');
  writeln;
  writeln('1000.th ',MagSumPerRow(1002));

  writeln('First Magic constants > 10^xx');
  //lmt = (rowcnt^3 + rowcnt) /2 -> rowcnt > (lmt*2 )^(1/3)
  lmt := 2.0 * 10.0;
  For i :=  1 to 50 do
  begin
    rowcnt := Int(exp(ln(lmt)/3))+1.0;//+1 suffices
    str(trunc(rowcnt),s);
    writeln('10^',i:2,#9,s:18);
    f := 10.0*lmt;
  end;
end.
