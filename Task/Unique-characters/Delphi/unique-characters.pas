var SA: array [0..2] of string = ('133252abcdeeffd',  'a6789798st',  'yxcdfgxcyz');

function CharsAppearingOnce(S: string): string;
{Return all character that only occur once}
var SL: TStringList;
var I,Inx: integer;
begin
SL:=TStringList.Create;
try
{Store each character and store a count}
{of the number of occurances in the object}
for I:=1 to Length(S) do
	begin
	{Check to see if letter is already in list}
	Inx:=SL.IndexOf(S[I]);
	{Increment the count if it is, otherwise store it}
	if Inx>=0 then SL.Objects[Inx]:=Pointer(Integer(SL.Objects[Inx])+1)
	else SL.AddObject(S[I],Pointer(1));
	end;
{Sort the list}
SL.Sort;
{Now return letters with a count of one}
Result:='';
for I:=0 to SL.Count-1 do
 if integer(SL.Objects[I])<2 then Result:=Result+SL[I];
finally SL.Free; end;
end;

procedure ShowUniqueChars(Memo: TMemo);
var I: integer;
var S: string;
begin
{Concatonate all strings}
S:='';
for I:=0 to High(SA) do S:=S+SA[I];
{Get all characters that appear once}
S:=CharsAppearingOnce(S);
Memo.Lines.Add(S);
end;


