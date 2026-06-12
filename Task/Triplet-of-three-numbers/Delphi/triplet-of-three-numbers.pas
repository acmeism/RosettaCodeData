procedure ShowTriplePrimes(Memo: TMemo);
var I: integer;
var Sieve: TPrimeSieve;
begin
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(10000);
for I:=1 to 6000-1 do
	begin
	if Sieve.Flags[I-1] and
	   Sieve.Flags[I+3] and
	   Sieve.Flags[I+5] then
		begin
		Memo.Lines.Add(Format('%d: %d %d %d',[I,I-1,I+3,I+5]));
		end;
	end;

finally Sieve.Free; end;
end;

