type TTerm = function(i: integer): real;

function Term(I: integer): double;
begin
Term := 1 / I;
end;


function Sum(var I: integer; Lo, Hi: integer; Term: TTerm): double;
begin
Result := 0;
I := Lo;
while I <= Hi do
	begin
	Result := Result + Term(I);
	Inc(I);
	end;
end;


procedure ShowJensenDevice(Memo: TMemo);
var I: LongInt;
begin
Memo.Lines.Add(FloatToStrF(Sum(I, 1, 100, @Term), ffFixed,18,15));
end;
