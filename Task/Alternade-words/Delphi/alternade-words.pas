unit Alternade;

interface

uses Classes,StdCtrls,SysUtils;

procedure FindAlternadeWords(Memo: TMemo);

implementation

var Dict: TStringList;	{List holds dictionary}

function GetAlts(S: string; var Alt1,Alt2: string): boolean;
{Grab Alternades from string and test if they are valid }
var I: integer;
begin
Alt1:='';
Alt2:='';
{Copy every other letter into different string}
for I:=1 to Length(S) do
 if (I mod 2)=0 then Alt2:=Alt2+S[I]
 else Alt1:=Alt1+S[I];
{Check if the two strings are in the dictionary}
Result:=(Dict.IndexOf(Alt1)>=0) and (Dict.IndexOf(Alt2)>=0);
end;

procedure FindAlternadeWords(Memo: TMemo);
{test all words in the dictionary}
{And diplays the Alternade words in the Memo}
var I,Cnt: integer;
var Alt1,Alt2: string;
begin
Cnt:=0;
for I:=0 to Dict.Count-1 do
 if (Length(Dict[I])>=6) and GetAlts(Dict[I], Alt1, Alt2) then
	begin
	Inc(Cnt);
	Memo.Lines.Add(IntToStr(Cnt)+': '+Dict[I]+' '+Alt1+' '+Alt2);
	end
end;


initialization
{Create/load dictionary}
Dict:=TStringList.Create;
Dict.LoadFromFile('unixdict.txt');
Dict.Sorted:=True;
finalization
Dict.Free;
end.

