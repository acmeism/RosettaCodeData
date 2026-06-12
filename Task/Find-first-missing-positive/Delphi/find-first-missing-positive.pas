var List1: array [0..2] of integer =(1,2,0);
var List2: array [0..3] of integer =(3,4,-1,1);
var List3: array [0..4] of integer =(7,8,9,11,12);

function FindMissingInt(IA: array of integer): integer;
var I,Inx: integer;
var List: TList;
begin
List:=TList.Create;
try
Result:=-1;
for I:=0 to High(IA) do List.Add(Pointer(IA[I]));
for Result:=1 to High(integer) do
	begin
	Inx:=List.IndexOf(Pointer(Result));
	if Inx<0 then exit;
	end;
finally List.Free; end;
end;


function GetIntStr(IA: array of integer): string;
var I: integer;
begin
Result:='[';
for I:=0 to High(IA) do
	begin
	if I>0 then Result:=Result+',';
	Result:=Result+Format('%3.0d',[IA[I]]);
	end;
Result:=Result+']';
end;



procedure ShowMissingInts(Memo: TMemo);
var S: string;
var M: integer;
begin
S:=GetIntStr(List1);
M:=FindMissingInt(List1);
Memo.Lines.Add(S+' = '+IntToStr(M));

S:=GetIntStr(List2);
M:=FindMissingInt(List2);
Memo.Lines.Add(S+' = '+IntToStr(M));

S:=GetIntStr(List3);
M:=FindMissingInt(List3);
Memo.Lines.Add(S+' = '+IntToStr(M));
end;


