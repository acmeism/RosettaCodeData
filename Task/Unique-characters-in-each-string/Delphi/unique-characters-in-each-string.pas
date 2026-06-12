var SA: array [0..2] of string = ('1a3c52debeffd', '2b6178c97a938stf', '3ycxdb1fgxa2yz');


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


function CommonToAllStrs(SA: array of string): string;
{Get all the letters shared by all the strings in SA}
var I,J,Cnt: integer;
var S1: string;
var C: char;
begin
Result:='';
{Exit if empty array}
if Length(SA)<1 then exit;
{Get the first string}
S1:=SA[0];
for I:=1 to Length(S1) do
	begin
	{Character from 1st string }
	C:=S1[I];
	{Count # of occurences}
	Cnt:=1;
	for J:=1 to High(SA) do
	 if Pos(C,SA[J])>0 then Inc(Cnt);
	{grab it if it appears in all other string}
	if Cnt=Length(SA) then Result:=Result+C;
	end;
end;

procedure ShowCharsAppearOnce(Memo: TMemo);
var I: integer;
var S: string;
var SS: array of string;
begin
SetLength(SS,0);
{Get all single appearance characters}
for I:=0 to High(SA) do
	begin
	SetLength(SS,Length(SS)+1);
	SS[High(SS)]:=CharsAppearingOnce(SA[I]);
	end;
{Get the ones shared by all string}
S:=CommonToAllStrs(SS);
Memo.Lines.Add(S);
end;
