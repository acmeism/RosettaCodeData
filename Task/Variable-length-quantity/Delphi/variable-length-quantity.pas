function NumberToVLQ(Num: int64): string;
{Convert Num to Variable-Length Quantity VLQ Octets (bytes)}
{Octet = 7-bit data and MSB indicating the last data item = 0 }
{Note: String are being used as byte-array because they are easy}
var I: integer;
var T: byte;
var BA: string;
begin
Result:='';
BA:='';
{Get array of octets}
while Num>0 do
	begin
	BA:=BA+char($7F and Num);
	Num:=Num shr 7;
	end;
{Reverse data and flag more data is coming}
Result:='';
for I:=Length(BA) downto 1 do
	begin
	T:=Byte(BA[I]);
	if I<>1 then T:=T or $80;
	Result:=Result+char(T);
	end;
end;


function VLQToNumber(VLQ: string): int64;
{Convert Variable-Length Quantity VLQ Octets (bytes) to numbers}
{Octet = 7-bit data and MSB indicating the last data item = 0 }
{Note: String are being used as byte-array because they are easy}
var I: integer;
var T: byte;
var BA: string;
begin
Result:=0;
for I:=1 to Length(VLQ) do
Result:=(Result shl 7) or (Byte(VLQ[I]) and $7F);
end;



function VLQToString(VLQ: string): string;
{Convert VLQ to string of hex numbers}
var I: integer;
begin
Result:='(';
for I:=1 to Length(VLQ) do
	begin
	if I>1 then Result:=Result+', ';
	Result:=Result+IntToHex(byte(VLQ[I]),2);
	end;
Result:=Result+')';
end;



procedure ShowVLQ(Memo: TMemo; Num: int64);
var VLQ: string;
var I: int64;
var S: string;
begin
VLQ:=NumberToVLQ(Num);
S:=VLQToString(VLQ);
I:=VLQToNumber(VLQ);
Memo.Lines.Add('Original Number:  '+Format('%x',[Num]));
Memo.Lines.Add('Converted to VLQ: '+Format('%s',[S]));
Memo.Lines.Add('Back to Original: '+Format('%x',[I]));
Memo.Lines.Add('');
end;

const Num1 = $0;
const Num2 = $7F;
const Num3 = $4000;
const Num4 = $1FFFFF;
const Num5 = $200000;
const Num6 = $3FFFFE;
const Num7 = $3311A1234DF31413;



procedure VariableLengthOctets(Memo: TMemo);
begin
ShowVLQ(Memo, Num1);
ShowVLQ(Memo, Num2);
ShowVLQ(Memo, Num3);
ShowVLQ(Memo, Num4);
ShowVLQ(Memo, Num5);
ShowVLQ(Memo, Num6);
ShowVLQ(Memo, Num7);
end;
