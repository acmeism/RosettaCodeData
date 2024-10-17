const MaxNumber = 100000000;
var DSum: array [0..MaxNumber-1] of integer;
var DCount: array [0..MaxNumber-1] of integer;

procedure ShowErdosNicolasNumbers(Memo: TMemo);
var I,J: integer;
begin
for I:=0 to MaxNumber-1 do
	begin
	DSum[I]:=1;
	DCount[I]:=1;
	end;
for I:=2 to MaxNumber-1 do
	begin
	J:=I*2;
	while J<MaxNumber do
		begin
		if dsum[J] = j then
			begin
			Memo.Lines.Add(Format('%8d equals the sum of its first %d divisors', [j, dcount[j]]));
			end;
		Inc(dsum[J],I);
		Inc(DCount[J]);
		Inc(J,I);
		end;
        end;
end;
