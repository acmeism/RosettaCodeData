var ThreeList: array [0..4,0..8] of integer = (
    (9,3,3,3,2,1,7,8,5),
    (5,2,9,3,3,7,8,4,1),
    (1,4,3,6,7,3,8,3,2),
    (1,2,3,4,5,6,7,8,9),
    (4,6,8,7,2,3,3,3,1));


function CountThrees(TA: array of integer): integer;
{Count the number threes in array}
var I,Cnt: integer;
begin
Result:=0;
for I:=0 to High(TA) do
 if TA[I]=3 then
    begin
    Inc(Result);
    if Result=3 then exit;
    end
 else Result:=0;
end;


procedure TestThreeArrays(Memo: TMemo);
var I,J: integer;
var B: boolean;
var S: string;
begin
for I:=0 to High(ThreeList) do
    begin
    S:='';
    for J:=0 to High(ThreeList[I]) do
        begin
        if J>0 then S:=S+',';
        S:=S+IntToStr(ThreeList[I][J])
        end;
    if CountThrees(ThreeList[I])=3 then S:=S+' True'
    else S:=S+' False';
    Memo.Lines.Add(S);
    end;
end;

