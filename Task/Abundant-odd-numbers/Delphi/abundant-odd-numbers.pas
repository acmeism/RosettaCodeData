program AbundantOddNumbers;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function SumProperDivisors(const N: Cardinal): Cardinal;
var
  I, J: Cardinal;
begin
  Result := 1;
  I := 3;
  while I < Sqrt(N)+1 do begin
    if N mod I = 0 then begin
      J := N div I;
      Inc(Result, I);
      if I <> J then Inc(Result, J);
    end;
    Inc(I, 2);
  end;
end;

var
  C, N: Cardinal;
begin
  N := 1;
  C := 0;
  while C < 25 do begin
    Inc(N, 2);
    if N < SumProperDivisors(N) then begin
      Inc(C);
      WriteLn(Format('%u: %u', [C, N]));
    end;
  end;

  while C < 1000 do begin
    Inc(N, 2);
    if N < SumProperDivisors(N) then Inc(C);
  end;
  WriteLn(Format('The one thousandth abundant odd number is: %u', [N]));

  N := 1000000001;
  while N >= SumProperDivisors(N) do Inc(N, 2);
  WriteLn(Format('The first abundant odd number above one billion is: %u', [N]));

end.
