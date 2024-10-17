{Complex number}

type TComplex = record
 Real,Imagine: double;
 end;

{Tolerance for fuzzy integer test}

const Tolerance = 0.00001;

function IsFloatInteger(R,Fuzz: extended): boolean;
{Determine if floating point number is an integer}
var F: extended;
begin
F:=Abs(Frac(R));
if IsNan(R) or IsInfinite(R) then Result:=False
else Result:=(F<=Fuzz) or ((1-F)<=Fuzz);
end;


function IsComplexInteger(C: TComplex; Fuzz: extended): boolean;
{Determine if Complex number is an integer}
begin
Result:=(C.Imagine=0) and IsFloatInteger(C.Real,Fuzz);
end;

function GetBooleanStr(B: boolean): string;
{Return Yes/No string depending on boolean}
begin
if B then Result:='Yes' else Result:='No';
end;


procedure DisplayFloatInteger(Memo: TMemo; R: extended);
{Display test result for single floating point number}
var S: string;
var B1,B2: boolean;
begin
B1:=IsFloatInteger(R,0);
B2:=IsFloatInteger(R,Tolerance);
Memo.Lines.Add(Format('%15.6n, Is Integer = %3S Fuzzy = %3S',[R,GetBooleanStr(B1),GetBooleanStr(B2)]));
end;


procedure DisplayComplexInteger(Memo: TMemo; C: TComplex);
{Dispaly test result for single complex number}
var S: string;
var B1,B2: boolean;
begin
B1:=IsComplexInteger(C,0);
B2:=IsComplexInteger(C,Tolerance);
Memo.Lines.Add(Format('%3.1n + %3.1ni Is Integer = %3S Fuzzy = %3S',[C.Real,C.Imagine,GetBooleanStr(B1),GetBooleanStr(B2)]));
end;


procedure TestIntegerness(Memo: TMemo);
var C: TComplex;
begin
DisplayFloatInteger(Memo,25.000000);
DisplayFloatInteger(Memo,24.999999);
DisplayFloatInteger(Memo,25.000100);
DisplayFloatInteger(Memo,-2.1e120);
DisplayFloatInteger(Memo,-5e-2);
DisplayFloatInteger(Memo,NaN);
DisplayFloatInteger(Memo,Infinity);
Memo.Lines.Add('');

C.Real:=5; C.Imagine:=0;
DisplayComplexInteger(Memo,C);
C.Real:=5; C.Imagine:=5;
DisplayComplexInteger(Memo,C);
end;
