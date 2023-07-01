type TCUSIPInfo = record
 ID,Company: string;
 end;

var CUSIPArray: array [0..5] of TCUSIPInfo = (
  (ID:'037833100'; Company: 'Apple Incorporated'),
  (ID:'17275R102'; Company: 'Cisco Systems'),
  (ID:'38259P508'; Company: 'Google Incorporated'),
  (ID:'594918104'; Company: 'Microsoft Corporation'),
  (ID:'68389X106'; Company: 'Oracle Corporation'),
  (ID:'68389X105'; Company: 'Oracle Corporation'));

function IsValidCUSIP(Info: TCUSIPInfo): boolean;
{Calculate checksum on first 7 chars of CUSIP }
{And compare with the last char - the checksum char}
var I,V,Sum: integer;
var C: char;
begin
Sum:=0;
for I:=1 to Length(Info.ID)-1 do
	begin
	C:=Info.ID[I];
	if C in ['0'..'9'] then V:=byte(C)-$30
	else if C in ['A'..'Z'] then V:=(byte(C)-$40) + 9
	else case C of
	 '*': V:=36;
	 '@': V:=37;
	 '#': V:=38;
	 end;
	if (I and 1)=0 then V:=V*2;
	Sum:=Sum + (V div 10) + (V mod 10);
	end;
Sum:=(10 - (Sum mod 10)) mod 10;
Result:=StrToInt(Info.ID[Length(Info.ID)])=Sum;
end;


procedure TestCUSIPList(Memo: TMemo);
{Test every item in the CSUIP array}
var I: integer;
var S: string;
begin
for I:=0 to High(CUSIPArray) do
	begin
	if IsValidCUSIP(CUSIPArray[I]) then S:='Valid' else S:='Invalid';
	Memo.Lines.Add(CUSIPArray[I].ID+'	'+CUSIPArray[I].Company+':	'+S);
	end;
end;
