{Structure to hold the data}

type TButcherInfo = record
 Name: string;
 Weight,Cost,PerKG: double;
 end;
type PButcherInfo = ^TButcherInfo;

{Array of actual data}

var Items: array [0..8] of TButcherInfo =(
	(Name: 'beef';    Weight: 3.8; Cost: 36.0),
	(Name: 'pork';    Weight: 5.4; Cost: 43.0),
	(Name: 'ham';     Weight: 3.6; Cost: 90.0),
	(Name: 'greaves'; Weight: 2.4; Cost: 45.0),
	(Name: 'flitch';  Weight: 4.0; Cost: 30.0),
	(Name: 'brawn';   Weight: 2.5; Cost: 56.0),
	(Name: 'welt';    Weight: 3.7; Cost: 67.0),
	(Name: 'salami';  Weight: 3.0; Cost: 95.0),
	(Name: 'sausage'; Weight: 5.9; Cost: 98.0)
	);


function CompareButcher(List: TStringList; Index1, Index2: Integer): Integer;
{Compare routine to sort by Per Kilograph cost}
var Info1,Info2: TButcherInfo;
begin
Info1:=PButcherInfo(List.Objects[Index1])^;
Info2:=PButcherInfo(List.Objects[Index2])^;
Result:=Trunc(Info2.PerKG * 100 - Info1.PerKG * 100);
end;


procedure KnapsackProblem(Memo: TMemo);
{Solve the knapsack problem}
var SL: TStringList;
var I,Inx: integer;
var Info: TButcherInfo;
var Weight,Cost,Diff: double;
const Limit = 15;
begin
SL:=TStringList.Create;
try
{Calculate the per Kilogram cost for each item}
for I:=0 to High(Items) do
	begin
	Items[I].PerKG:=Items[I].Cost/Items[I].Weight;
	SL.AddObject(Items[I].Name,@Items[I]);
	end;
{Sort most expensive items to top of list}
SL.CustomSort(CompareButcher);

{Take the most expensive items }
Weight:=0; Cost:=0;
for I:=0 to SL.Count-1 do
	begin
	Info:=PButcherInfo(SL.Objects[I])^;
	{Item exceeds the weight limit? }
	if (Weight+Info.Weight)>=Limit then
		begin
		{Calculate percent to fill gap}
		Diff:=(Limit-Weight)/Info.Weight;
		{Save index}
		Inx:=I;
		break;
		end
	else
		begin
		{Add up totals}
		Weight:=Weight+Info.Weight;
		Cost:=Cost+Info.Cost;
		end;
	end;

{Display all items}
Memo.Lines.Add('Item      Portion    Value');
Memo.Lines.Add('--------------------------');
for I:=0 to Inx-1 do
	begin
	Info:=PButcherInfo(SL.Objects[I])^;
	Memo.Lines.Add(Format('%-8s %8.2f %8.2f',[Info.Name,Info.Weight,Info.Cost]));
	end;
Info:=PButcherInfo(SL.Objects[Inx])^;
{Calculate cost and weight to fill gap}
weight:=Weight+Info.Weight*Diff;
Cost:=Cost+Info.Cost*Diff;
{Display gap filling item}
Memo.Lines.Add(Format('%-8s %8.2f %8.2f',[Info.Name,Info.Weight*Diff,Info.Cost*Diff]));
Memo.Lines.Add('--------------------------');
Memo.Lines.Add(Format('Totals   %8.2f %8.2f',[Weight,Cost]));
finally SL.Free; end;
end;
