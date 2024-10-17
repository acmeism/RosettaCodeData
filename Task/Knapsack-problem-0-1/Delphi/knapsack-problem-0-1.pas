{Item to store data in}

type TPackItem = record
 Name: string;
 Weight,Value: integer;
 end;

{List of items, weights and values}

const ItemsList: array [0..21] of TPackItem = (
   (Name: 'map'; Weight: 9; Value: 150),
   (Name: 'compass'; Weight: 13; Value: 35),
   (Name: 'water'; Weight: 153; Value: 200),
   (Name: 'sandwich'; Weight: 50; Value: 160),
   (Name: 'glucose'; Weight: 15; Value: 60),
   (Name: 'tin'; Weight: 68; Value: 45),
   (Name: 'banana'; Weight: 27; Value: 60),
   (Name: 'apple'; Weight: 39; Value: 40),
   (Name: 'cheese'; Weight: 23; Value: 30),
   (Name: 'beer'; Weight: 52; Value: 10),
   (Name: 'suntan cream'; Weight: 11; Value: 70),
   (Name: 'camera'; Weight: 32; Value: 30),
   (Name: 't-shirt'; Weight: 24; Value: 15),
   (Name: 'trousers'; Weight: 48; Value: 10),
   (Name: 'umbrella'; Weight: 73; Value: 40),
   (Name: 'waterproof trousers'; Weight: 42; Value: 70),
   (Name: 'waterproof overclothes'; Weight: 43; Value: 75),
   (Name: 'note-case'; Weight: 22; Value: 80),
   (Name: 'sunglasses'; Weight: 7; Value: 20),
   (Name: 'towel'; Weight: 18; Value: 12),
   (Name: 'socks'; Weight: 4; Value: 50),
   (Name: 'book'; Weight: 30; Value: 10));

{Iterater object to step through all the indices
{ corresponding to the bits in "N". This is used }
{ step through all the combinations of items }

type TBitIterator = class(TObject)
 private
   FNumber,FIndex: integer;
 public
  procedure Start(StartNumber: integer);
  function Next(var Index: integer): boolean;
 end;

procedure TBitIterator.Start(StartNumber: integer);
{Set the starting value of the number }
begin
FNumber:=StartNumber;
end;


function TBitIterator.Next(var Index: integer): boolean;
{Return the next available index}
begin
Result:=False;
while FNumber>0 do
	begin
	Result:=(FNumber and 1)=1;
	if Result then Index:=FIndex;
	FNumber:=FNumber shr 1;
	Inc(FIndex);
	if Result then break;
	end;
end;

{=============================================================================}


procedure GetSums(N: integer; var Weight,Value: integer);
{Iterate through all indices corresponding to N}
{Get get the sum of their values}
var Inx: integer;
var BI: TBitIterator;
begin
BI:=TBitIterator.Create;
try
BI.Start(N);
Weight:=0; Value:=0;
while BI.Next(Inx) do
	begin
	Weight:=Weight+ItemsList[Inx].Weight;
	Value:=Value+ItemsList[Inx].Value;
	end;
finally BI.Free; end;
end;



procedure DoKnapsackProblem(Memo: TMemo);
{Find optimized solution to Knapsack problem}
{By iterating through all binary combinations}
var I,J,Inx: integer;
var Max: integer;
var WeightSum,ValueSum: integer;
var BestValue,BestIndex,BestWeight: integer;
var S: string;
var BI: TBitIterator;
begin
BI:=TBitIterator.Create;
try
{Get value that will cover all binary combinations}
Max:=1 shl Length(ItemsList)-1;
BestValue:=0;
{Iterate through all combinations of bits}
for I:=1 to Max do
	begin
	{Get the sum of the weights and values}
	GetSums(I,WeightSum,ValueSum);
	{Ignore any weight greater than 400}
	if WeightSum>400 then continue;
	{Test if this is the best value so far}
	if ValueSum>BestValue then
		begin
		BestValue:=ValueSum;
		BestWeight:=WeightSum;
		BestIndex:=I;
		end;
	end;
{Display the best result}
Memo.Lines.Add('  Item                    Weight  Value');
Memo.Lines.Add('---------------------------------------');
BI.Start(BestIndex);
while BI.Next(Inx) do
	begin
	S:='  '+Format('%-25s',[ItemsList[Inx].Name]);
	S:=S+Format('%5d',[ItemsList[Inx].Weight]);
	S:=S+Format('%7d',[ItemsList[Inx].Value]);
	Memo.Lines.Add(S);
	end;
Memo.Lines.Add('---------------------------------------');
Memo.Lines.Add(Format('Total                     %6d %6d',[BestWeight,BestValue]));
Memo.Lines.Add('Best Inx: '+IntToStr(BestIndex));
Memo.Lines.Add('Best Value: '+IntToStr(BestValue));
Memo.Lines.Add('Best Weight: '+IntToStr(BestWeight));
finally BI.Free; end;
end;
