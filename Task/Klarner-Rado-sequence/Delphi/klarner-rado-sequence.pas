function SortCompare(Item1, Item2: Pointer): Integer;
{Custom compare to order the list}
begin
Result:=Integer(Item1)-Integer(Item2);
end;

procedure KlarnerRadoSeq(Memo: TMemo);
{Display Klarner-Rado sequence}
var LS: TList;
var I,N: integer;
var S: string;

	procedure AddItem(N: integer);
	{Add item to list avoiding duplicates}
	begin
	if LS.IndexOf(Pointer(N))>=0 then exit;
	LS.Add(Pointer(N));
	end;

	function FormatInx(Inx: integer): string;
	{Specify an index into the array}
	{Returns a formated number}
	var D: double;
	begin
	D:=Integer(LS[Inx]);
	Result:=Format('%11.0n',[D]);
	end;

begin
LS:=TList.Create;
try
{Add string value}
LS.Add(Pointer(1));
{Add two new items to the list}
for I:=0 to high(integer) do
	begin
	N:=Integer(LS[I]);
	AddItem(2 * N + 1);
	AddItem(3 * N + 1);
	if LS.Count>=100001 then break;
	end;
{Put the data in numerical order}
LS.Sort(SortCompare);
{Display data}
S:='[';
for I:=0 to 99 do
	begin
	if I<>0 then S:=S+' ';
	S:=S+Format('%4d',[Integer(LS[I])]);
	if (I mod 10)=9 then
		begin
		if I=99 then S:=S+']';
		S:=S+#$0D#$0A;
		end;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('The   1,000th '+FormatInx(1000));
Memo.Lines.Add('The  10,000th '+FormatInx(10000));
Memo.Lines.Add('The 100,000th '+FormatInx(100000));
finally LS.Free; end;
end;
