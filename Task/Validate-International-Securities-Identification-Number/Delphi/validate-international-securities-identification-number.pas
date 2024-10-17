function StrToBase10(S: string): TByteDynArray;
{Convert ASCII string to Base-10}
{ASCII Digits converted to integer 0..9 }
{ASCII Chars convert to bytes "A"=10, "B"=11, etc }
var I: Integer;
var B: byte;

	procedure StoreByte(B: byte);
	begin
	SetLength(Result,Length(Result)+1);
	Result[High(Result)]:=B;
	end;

begin
SetLength(Result,0);
for I:=1 to Length(S) do
	begin
	if S[I] in ['0'..'9'] then StoreByte(Byte(S[I])-$30)
	else
		begin
		B:=(Byte(S[I])-$41)+10;
		StoreByte(B div 10);
		StoreByte(B mod 10);
		end;
	end;
end;

{Simplifies cases where we have to sum a two digit number}

const DigitSum: array [0..18] of byte = (0,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9);

function LuhnTest(Nums: array of byte): boolean;
{Perform Luhn Test of byte array}
var I,J,Len,Sum,Sum1,Sum2: integer;
var Rev: array of byte;
begin
Sum1:=0; Sum2:=0;
Len:=High(Nums);
for I:=Len downto 0 do
 if ((I-Len) and 1)=0 then Sum1:=Sum1 + Nums[I]
 else Sum2:=Sum2 + DigitSum[Nums[I]*2];
Sum:=Sum1+Sum2;
Result:=(Sum mod 10)=0;
end;

{String error types}

type TStringErrors = (seNone,seLength,seCountry);

function ValidateStr(IDStr: string): TStringErrors;
{Validate string checking for incorrectly length}
{And invalid country code}
begin
if Length(IDStr)<>12 then Result:=seLength
else if not (IDStr[1] in ['a'..'z','A'..'Z']) or
        not (IDStr[2] in ['a'..'z','A'..'Z']) then Result:=seCountry
else Result:=seNone;
end;



procedure ValidateID(Memo: TMemo; IDStr: string);
{Validate and display status of string}
var BA: TByteDynArray;
var LT: boolean;
var SE: TStringErrors;
var S: string;
begin
SE:=ValidateStr(IDStr);
BA:=StrToBase10(IDStr);
LT:=LuhnTest(BA);
if LT and (SE=seNone) then Memo.Lines.Add(IDStr+': Valid')
else
	begin
	S:=IDStr+': Invalid';
	if not LT then S:=S+', Luhn Error';
	case SE of
	 seLength: S:=S+', Length Error';
	 seCountry: S:=S+', Country Code Error';
	 end;
	Memo.Lines.Add(S);
	end;
end;



procedure ValidateSecuritiesID(Memo: TMemo);
var BA: TByteDynArray;
var I: integer;
var S: string;
begin
ValidateID(Memo,'US0378331005');
ValidateID(Memo,'US0373831005');
ValidateID(Memo,'U50378331005');
ValidateID(Memo,'US03378331005');
ValidateID(Memo,'AU0000XVGZA3');
ValidateID(Memo,'AU0000VXGZA3');
ValidateID(Memo,'FR0000988040');
end;
