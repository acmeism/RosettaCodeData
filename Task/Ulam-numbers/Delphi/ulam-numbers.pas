function GetUlamNumber(N: integer): integer;
var Ulams: array of integer;
var U,ULen,I: integer;
var Sieve: array of integer;
begin
SetLength(Ulams,Max(N,2));
Ulams[0]:= 1;
Ulams[1]:= 2;
SetLength(Sieve, 2);
Sieve[0]:=1;
Sieve[1]:= 1;
U:=2; ULen:=2;
while Ulen < N do
	begin
	SetLength(Sieve,U + Ulams[Ulen - 2]);
	for I:= 0 to ulen - 2 do
	Sieve[u + Ulams[I] - 1]:=Sieve[u + Ulams[i] - 1]+1;
	for I:=U to High(Sieve) do
	 if Sieve[I] = 1 then
		begin
		U:=I + 1;
		Ulams[Ulen]:=U;
		Inc(ULen);
		break;
		end;
	end;
Result:=ULams[N - 1];
end;



procedure ShowUlamNumbers(Memo: TMemo);
var N: integer;
var S: string;
begin
N:=1;
while N<=100000 do
	begin
	S:=Format('Ulam(%d)',[N]);
	Memo.Lines.Add(Format('%-12S = %8d', [S, GetUlamNumber(N)]));
	N:=N * 10
	end;
end;


