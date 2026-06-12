program SumOfDgtsIsSubString;
{$MODE DELPHI}
uses
  sysutils;
//using string s to get digits as I already need s to find the substring.
function GetSumDigits(const s: Ansistring):Uint64;
var
  i : Int32;
begin
  result := 0;
  For i := length(s) downto 1 do
    result += Ord(S[i]) -Ord('0');
end;

procedure SumDigitsSubstring;
var
  numS,sumS,OutS: AnsiString;
  cnt,n : Uint32;
begin
  OutS:='';
  Cnt:=0;
  N:=0;
  repeat
    str(n,numS);
    str(GetSumDigits(numS),sumS);
    if Pos(sumS,numS)>0 then
    begin
      Inc(Cnt);
      OutS += Format('%10d',[N]);
      if (Cnt mod 8)=0 then
        OutS += #13#10;
    end;
    inc(n);
  until n>=1000;
  writeln(OutS);
  writeln('Searched from 0 to ',N-1);
  writeln('Found ',cnt,' which fulfill the criterion');
end;

Begin
 SumDigitsSubstring;
end.
