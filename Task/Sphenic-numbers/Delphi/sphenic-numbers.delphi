procedure GetSphenicNumbers(var Sphenic: TIntegerDynArray);
{Return Sphenic number up to MaxProd }
const MaxProd = 1000000;
var LimitA: integer;
var Sieve: TPrimeSieve;
var I,J,K,Prod1,Prod2: integer;
begin
Sieve:=TPrimeSieve.Create;
try
SetLength(Sphenic,0);
{Limit outer most search}
LimitA:=Trunc(CubeRoot(MaxProd));
{Sieve values up to MaxProc ~ 78,000 primes }
Sieve.Intialize(MaxProd);
{Iteratre through all combination of sequential primes}
for I:=0 to Sieve.PrimeCount-1 do
	begin
	{Limit first prime}
	if Sieve.Primes[I]>LimitA then break;
	for J:=I+1 to Sieve.PrimeCount-1 do
		begin
		Prod1:=Sieve.Primes[I] * Sieve.Primes[J];
		{Limit product of first two primes}
		if (Prod1 * Sieve.Primes[J + 1])>=MaxProd then break;
		for K:=J+1 to Sieve.PrimeCount-1 do
			begin
			Prod2:= Prod1 * Sieve.Primes[k];
			{Limit product of all three primes}
			if Prod2 >=MaxProd then break;
			{Store number}
			SetLength(Sphenic,Length(Sphenic)+1);
			Sphenic[High(Sphenic)]:=Prod2;
			end;
		end;
	end;
finally Sieve.Free; end;
end;



function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Integer(P1)-Integer(P2);
end;

{Struct to store Sphenic Triple}

type TSphenicTriple = record
 A,B,C: integer;
 end;

{Dynamic array to store triples}

type TTripletArray = array of TSphenicTriple;

procedure GetSphenicTriples(var Triplets: TTripletArray; var Sphenic: TIntegerDynArray);
{Get sphenic numbers and find corresponding sphenic triples}
var LS: TList;
var I,T: integer;
begin
LS:=TList.Create;
GetSphenicNumbers(Sphenic);
{Sort the numbers}
for I:=0 to High(Sphenic) do
 LS.Add(Pointer(Sphenic[I]));
LS.Sort(Compare);
{Put them back in simple array}
for I:=0 to LS.Count-1 do
 Sphenic[I]:=Integer(LS[I]);
SetLength(Triplets,0);
for I:=0 to High(Sphenic)-1 do
	begin
	T:=Sphenic[I];
	{Test if the next three numbers are a triple}
	if (Sphenic[I+1]=(T+1)) and (Sphenic[I+2] = (T + 2)) then
		begin
		{Store the result}
		SetLength(Triplets,Length(Triplets)+1);
		Triplets[High(Triplets)].A:=T;
		Triplets[High(Triplets)].B:=T+1;
		Triplets[High(Triplets)].C:=T+2;
		end;
	end;
end;

procedure SphenicTriplets(Memo: TMemo);
var Triplets: TTripletArray;
var T: TSphenicTriple;
var Sphenic: TIntegerDynArray;
var S: string;
var I: integer;
begin
{Get sphenic numbers and triples}
GetSphenicTriples(Triplets,Sphenic);
{Display sphenic numbers up to 1000}
Memo.Lines.Add('Sphenic numbers less than 1,000:');
S:='';
for I:=0 to High(Sphenic) do
	begin
	if Sphenic[I]>1000 then break;
	S:=S+Format('%4d',[Sphenic[I]]);
	if (I mod 15)=14 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
{Display sphenic triples up to a C-value of 10,000}
Memo.Lines.Add('Sphenic triples less than 10,000:');
S:='';
for I:=0 to High(Triplets) do
	begin
	if Triplets[I].C> 10000 then break;
	S:=S+Format('[%5d %5d %5d]',[Triplets[I].A,Triplets[I].B,Triplets[I].C]);
	if (I mod 3)=2 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('Total Sphenic Numbers found = '+FloatToStrF(Sphenic[Length(Sphenic)],ffNumber,18,0));
Memo.Lines.Add(Format('Sphenic numbers  < 1,000,000 = %8.0n',[Length(Sphenic)+0.0]));
Memo.Lines.Add(Format('Sphenic triplets < 1,000,000 = %8.0n',[Length(Triplets)+0.0]));
T:=Triplets[4999];
Memo.Lines.Add(Format('200,000th sphenic =   %n',[Sphenic[199999]+0.0]));
Memo.Lines.Add(Format('The 5,000th triplet = %d %d %d', [T.A,T.B,T.C]));
end;
