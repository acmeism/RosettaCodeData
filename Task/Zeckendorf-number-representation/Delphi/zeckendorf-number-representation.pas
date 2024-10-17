const FibNums: array [0..21] of integer =
      (1, 2, 3, 5, 8, 13, 21, 34, 55, 89,
       144, 233, 377, 610, 987, 1597, 2584,
       4181, 6765, 10946, 17711, 28657);


function GetZeckNumber(N: integer): string;
{Returns Zeckendorf number for N as string}
var I: integer;
begin
Result:='';
{Subtract Fibonacci numbers from N}
for I:=High(FibNums) downto 0 do
 if (N-FibNums[I])>=0 then
	begin
	Result:=Result+'1';
	N:=N-FibNums[I];
	end
 else if Length(Result)>0 then Result:=Result+'0';
if Result='' then Result:='0';
end;


procedure ShowZeckendorfNumbers(Memo: TMemo);
var I: integer;
var S: string;
begin
S:='';
for I:=0 to 20 do
	begin
	Memo.Lines.Add(IntToStr(I)+': '+GetZeckNumber(I));
	end;
end;
