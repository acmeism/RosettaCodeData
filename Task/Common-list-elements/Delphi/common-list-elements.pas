const Set1: set of byte = [2,5,1,3,8,9,4,6];
const Set2: set of byte = [3,5,6,2,9,8,4];
const Set3: set of byte = [1,3,7,6,9];


procedure CommonListElements(Memo: TMemo);
{Using Delphi "sets" to find common elements}
var I,Start,Stop: integer;
var Common: set of byte;
var S: string;
begin
{Uses "*" intersection set operator to}
{ find items common to all three sets}
Common:=Set1 * Set2 * Set3;
Memo.Lines.Add('Common Elements in');
Memo.Lines.Add(' [2,5,1,3,8,9,4,6]');
Memo.Lines.Add(' [3,5,6,2,9,8,4]');
Memo.Lines.Add(' [1,3,7,6,9]: ');
S:='';
{Display the common items}
for I:=0 to 9 do
 if I in Common then S:=S+IntToStr(I)+',';
Memo.Lines.Add(S);
end;

