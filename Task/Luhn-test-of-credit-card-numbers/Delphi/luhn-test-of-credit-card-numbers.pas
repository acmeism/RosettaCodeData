{Test data arrays}

const Num1: array [0..10] of byte = (4,9,9,2,7,3,9,8,7,1,6);
const Num2: array [0..10] of byte = (4,9,9,2,7,3,9,8,7,1,7);
const Num3: array [0..15] of byte = (1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8);
const Num4: array [0..15] of byte = (1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,0);

{Simplifies cases where we have to sum a two digit number}

const DigitSum: array [0..18] of byte = (0,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9);

function ValidateCreditCard(CardNum: array of byte): boolean;
{Validate a Credit Card number}
var I,J,Len,Sum,Sum1,Sum2: integer;
var Rev: array of byte;
begin
Sum1:=0; Sum2:=0;
Len:=High(CardNum);
for I:=Len downto 0 do
 if ((I-Len) and 1)=0 then Sum1:=Sum1 + CardNum[I]
 else Sum2:=Sum2 + DigitSum[CardNum[I]*2];
Sum:=Sum1+Sum2;
Result:=(Sum mod 10)=0;
end;


function CardNumberToStr(CardNum: array of byte): string;
{Convert card number to a string}
var I: integer;
begin
Result:='';
for I:=0 to High(CardNum) do
Result:=Result+IntToStr(CardNum[I]);
end;


procedure TestDisplayNumber(Memo: TMemo; Num: array of byte);
{Test a credit card number and display results}
var S: string;
begin
S:=CardNumberToStr(Num);
if ValidateCreditCard(Num) then S:=S+': Valid'
else S:=S+': Not Valid';
Memo.Lines.Add(S);
end;


procedure TestCreditCardNums(Memo: TMemo);
{Test all credit card numbers}
begin
TestDisplayNumber(Memo,Num1);
TestDisplayNumber(Memo,Num2);
TestDisplayNumber(Memo,Num3);
TestDisplayNumber(Memo,Num4);
end;
