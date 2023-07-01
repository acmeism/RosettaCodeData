{{works with| Delphi-6 or better}}
program ArithmeiticNumbers;

{$APPTYPE CONSOLE}

procedure ArithmeticNumbers;
var N, ArithCnt, CompCnt, DDiv: integer;
var DivCnt, Sum, Quot, Rem: integer;
begin
N:= 1;  ArithCnt:= 0;  CompCnt:= 0;
repeat
	begin
	DDiv:= 1;  DivCnt:= 0;  Sum:= 0;
	while true do
		begin
		Quot:= N div DDiv;
		Rem:=N mod DDiv;
		if Quot < DDiv then break;
		if (Quot = DDiv) and (Rem = 0) then //N is a square
			begin
			Sum:= Sum+Quot;
			DivCnt:= DivCnt+1;
			break;
			end;
		if Rem = 0 then
			begin
			Sum:= Sum + DDiv + Quot;
			DivCnt:= DivCnt+2;
			end;
		DDiv:= DDiv+1;
		end;
	if (Sum mod DivCnt) = 0 then //N is arithmetic
		begin
		ArithCnt:= ArithCnt+1;
		if ArithCnt <= 100 then
			begin
			Write(N:4);
			if (ArithCnt mod 20) = 0 then WriteLn;
			end;
		if DivCnt > 2 then CompCnt:= CompCnt+1;
		case ArithCnt of 1000, 10000, 100000, 1000000:
			begin
			Writeln;
			Write(N, #9 {tab} );
			Write(CompCnt);
			end;
	 	 end;
	 	end;
        N:= N+1;
        end
until   ArithCnt >= 1000000;
WriteLn;
end;

begin
ArithmeticNumbers;
WriteLn('Hit Any Key');
ReadLn;
end.
