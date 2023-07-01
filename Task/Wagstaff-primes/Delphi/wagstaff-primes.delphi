procedure WagstaffPrimes(Memo: TMemo);
{Finds Wagstaff primes up to 6^64}
var P,B,R: int64;
var Cnt: integer;
begin
{B is int64 to force 64-bit arithmetic}
P:=0; B:=1; Cnt:=0;
Memo.Lines.Add(' #:  P              (2^P + 1)/3');
while P<64 do
	begin
	R:=((B shl P) + 1) div 3;
	if IsPrime(P) and IsPrime(R) then
		begin
		Inc(Cnt);
		Memo.Lines.Add(Format('%2d: %2d %24.0n',[Cnt,P,R+0.0]));
		end;
	Inc(P);
	end;
end;
