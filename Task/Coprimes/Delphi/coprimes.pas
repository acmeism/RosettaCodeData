function GreatestCommonDivisor(A,B: integer): integer;
begin
if B = 0 then Result:=A
else Result:=GreatestCommonDivisor( B, A mod B);
end;


function IsCoprime(A,B: integer): boolean;
begin
Result:=GreatestCommonDivisor(A,B)=1;
end;


const TestNumbers: array [0..4] of TPoint =
((X:21;Y:15),(X:17;Y:23),(X:36;Y:12),(X:18;Y:29),(X:60;Y:15));


procedure ShowCoprimes(Memo: TMemo);
var I: integer;
var S: string;
var TN: TPoint;
begin
for I:=0 to High(TestNumbers) do
	begin
	TN:=TestNumbers[I];
	S:=IntToStr(TN.X)+' '+IntToStr(TN.Y)+' is ';
	if IsCoprime(TN.X,TN.Y) then S:=S+'coprime'
	else S:=S+'not coprime';
	Memo.Lines.Add(S);
	end;
end;

