function IsUpsideDown(N: integer): boolean;
{Test if N is upsidedown number}
var I,J: integer;
var IA: TIntegerDynArray;
begin
Result:=False;
{Get all digits in the number}
GetDigits(N,IA);
for I:=0 to Length(IA) div 2 do
	begin
	{Index to right side of number}
	J:=High(IA)-I;
	{do left and right side add up to 10?}
	if IA[J]+IA[I]<>10 then exit;
	{No zeros allowed}
	if (IA[J]=0) or (IA[I]=0) then exit;
	end;
Result:=True;
end;


procedure ShowUpsideDownNumbers(Memo: TMemo);
var I,J,K: integer;
var Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
{Show first 50 upside down numbers}
for I:=5 to high(integer) do
 if IsUpsideDown(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%5d',[I]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	if Cnt=50 then break;
	end;
Memo.Lines.Add(S);
{Show 500th, and 5,000th }
for I:=I to high(integer) do
 if IsUpsideDown(I) then
	begin
	Inc(Cnt);
	case Cnt of
	 500:  Memo.Lines.Add(Format('  500th Upsidedown = %10.0n',[I+0.0]));
	 5000: Memo.Lines.Add(Format('5,000th Upsidedown = %10.0n',[I+0.0]));
	 end;
	if Cnt>5000 then break;
	end;
end;



