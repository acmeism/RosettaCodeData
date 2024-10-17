{This code would normally be a separate library but is present her for clarity}

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

{------------------------------------------------------------------------------}


procedure NonSquareSums(Memo: TMemo);
var Squares: TCardinalDynArray;
var I,N,Cnt: integer;
var S: string;

	function GetSum(N: integer): integer;
	{Iterate through all indices corresponding to N}
	{Get get the sum of their values}
	var Inx: integer;
	var BI: TBitIterator;
	begin
	BI:=TBitIterator.Create;
	try
	BI.Start(N);
	Result:=0;
	while BI.Next(Inx) do
	 Result:=Result+Squares[Inx];
	finally BI.Free; end;
	end;

	function HasSquareSum(N: integer): boolean;
	{See if N is sum of squares}
	var I: integer;
	begin
	Result:=True;
	for I:=0 to High(Squares) do
	 if GetSum(I)=N then exit;
	Result:=False;
	end;


begin
{build array of squares for speed}
{64K^2 max 32-bit integer value}
SetLength(Squares,65536);
for I:=1 to High(Squares) do Squares[I-1]:=I*I;
S:=''; Cnt:=0;
{Test numbers up to sqrt(64K) = 64}
for I:=1 to trunc(sqrt(Length(Squares))) do
 if not HasSquareSum(I) then
	begin
	{display number that aren't sum of squares}
	Inc(Cnt);
	S:=S+Format('%4d',[I]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add('Numbers which are not the sum of distinct squares');
Memo.Lines.Add('Count = '+IntToStr(Cnt));
Memo.Lines.Add(S);
end;
