program Sudan;
//trans  https://rosettacode.org/wiki/Sudan_function#Delphi
{$IFDEF FPC} {$MODE DELPHI} {$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
function SudanFunction(N,X,Y: UInt64): UInt64;
begin
  if n = 0 then
    Result:=X + Y
   else
     if y = 0 then
       Result:=X
     else
       Result:=SudanFunction(N - 1, SudanFunction(N, X, Y - 1), SudanFunction(N, X, Y - 1) + Y);
end;

procedure ShowSudanFunction(N,X,Y: UInt64);
begin
  writeln(Format('Sudan(%d,%d,%d)=%d',[n,x,y,SudanFunction(N,X,Y)]));
end;

procedure ShowSudanFunctions;
var
  N,X,Y: UInt64;
  S: string;
begin
for N:=0 to 1 do
	begin
	writeln(Format('Sudan(%d,X,Y)',[N]));
	writeln('Y/X    0   1   2   3   4   5');
	writeln('----------------------------');
	for Y:=0 to 6 do
		begin
		S:=Format('%2d | ',[Y]);
		for X:=0 to 5 do
			begin
			S:=S+Format('%3d ',[SudanFunction(N,X,Y)]);
			end;
		writeln(S);
		end;
	writeln('');
	end;
end;	

BEGIN
  ShowSudanFunctions;
  ShowSudanFunction( 1, 3, 3);
  ShowSudanFunction( 2, 1, 1);
  ShowSudanFunction( 2, 2, 1);
  ShowSudanFunction( 2, 1, 2);
  ShowSudanFunction( 3, 1, 1);
  ShowSudanFunction( 2, 2, 2);
END.
