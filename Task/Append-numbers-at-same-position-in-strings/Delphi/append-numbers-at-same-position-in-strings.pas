const List1: array [0..8] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 9);
const list2: array [0..8] of integer = (10, 11, 12, 13, 14, 15, 16, 17, 18);
const list3: array [0..8] of integer = (19, 20, 21, 22, 23, 24, 25, 26, 27);

function GetAppendNumbers: string;
var I: integer;
begin
Result:='List = [';
for I:=0 to High(List1) do
    begin
    Result:=Result+IntToStr(List1[I])+IntToStr(List2[I])+IntToStr(List3[I]);
    if I=High(List1) then Result:=Result+']'
    else Result:=Result+',';
    end;
end;
