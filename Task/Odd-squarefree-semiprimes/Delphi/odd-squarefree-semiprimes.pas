function IsPrime(N: int64): boolean;
{Fast, optimised prime test}
var I,Stop: int64;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
     begin
     I:=5;
     Stop:=Trunc(sqrt(N+0.0));
     Result:=False;
     while I<=Stop do
           begin
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;


function CustomSort (Item1, Item2: Pointer): Integer;
begin
Result:=integer(Item1)-integer(Item2);
end;


procedure OddSquareFreeSemiprimes(Memo: TMemo);
var P,Q,I: integer;
const Limit = 1000;
var LS: TList;
var S: string;
begin
LS:=TList.Create;
try
P:=1;
{Test all relevant combinations of P and Q}
for P:=1 to Limit div 5 do
	begin
	if ((P and 1)=0) or (not IsPrime(P)) then continue;
	for Q:=P+2 to Limit div P do
		begin
		if ((Q and 1)=0) or (not IsPrime(Q)) then continue;
		{Put in list}
		LS.Add(Pointer(P*Q))
		end;
	end;
{List is not in order, so sort it}
LS.Sort(CustomSort);
S:='';
for I:=0 to LS.Count-1 do
	begin
	S:=S+Format('%8D',[Integer(LS[I])]);
	If (I mod 5)=4 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(LS.Count));
finally LS.Free; end;
end;


