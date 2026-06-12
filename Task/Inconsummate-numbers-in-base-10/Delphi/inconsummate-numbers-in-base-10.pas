function IsCosumate(N: integer): boolean;
{Test is number is consumate = V / SumDigits(V) = N}
var I, V: integer;
begin
Result:=True;
for I:=1 to High(integer) do
	begin
	{Test values for V that are multiples of N}
	V:= I * N;
	{Satisfy - V / SumDigits(V) = N? then exit}
        if V = (N * SumDigits(V)) then exit;
        {This value derrive by trial and error}
	if V>=29000000 then break;
        end;
Result:=False;
end;


procedure InconsummateNumbers(Memo: TMemo);
var S: string;
var N,I: integer;
begin
{Display first 50 inconsummate numbers}
N:=1; S:='';
for I:=1 to 50 do
	begin
	while IsCosumate(N) do Inc(N);
	S:=S+Format('%5D',[N]);
	if (I mod 10)=0 then S:=S+CRLF_Char;
	Inc(N);
	end;
Memo.Lines.Add(S);
{Then display 1,000th, 10,000th and 100,000th}
N:=1;
for I:=1 to 100000 do
	begin
	while IsCosumate(N) do Inc(N);
	if I=1000 then Memo.Lines.Add(  Format('  1,000th = %7.0n',[N+0.0]));
	if I=10000 then Memo.Lines.Add( Format(' 10,000th = %7.0n',[N+0.0]));
	if I=100000 then Memo.Lines.Add(Format('100,000th = %7.0n',[N+0.0]));
	Inc(N);
	end;
end;



