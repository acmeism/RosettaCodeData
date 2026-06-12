const Coins: array [0..7] of integer = (1,2,5,10,20,50,100,200);

procedure MinimumCoins(Memo: TMemo; Value: integer);
var I,C: integer;
begin
Memo.Lines.Add('Providing Change for: '+IntToStr(Value));
for I:=High(Coins) downto 0 do
	begin
	C:=Value div Coins[I];
	Value:=Value mod Coins[I];
	Memo.Lines.Add(IntToStr(C)+' coins of '+IntToStr(Coins[I]));
	end;
Memo.Lines.Add('');
end;


procedure TestMinimumCoins(Memo: TMemo);
begin
MinimumCoins(Memo,988);
MinimumCoins(Memo,1307);
MinimumCoins(Memo,37511);
MinimumCoins(Memo,0);
end;


