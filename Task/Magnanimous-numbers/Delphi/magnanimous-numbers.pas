function IsPrime(N: int64): boolean;
{Fast, optimised prime test}
var I,Stop: int64;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
     begin
     I:=5;
     Stop:=Trunc(sqrt(N+0.0));
     Result:=False;
     while I<=Stop do
           begin
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;

function IsMagnanimous(N: Integer): boolean;
var S,S1,S2: string;
var I,I1,I2: integer;
begin
Result:=True;
if N<10 then exit;
Result:=False;
S:=IntToStr(N);
for I:=2 to Length(S) do
	begin
	S1:=Copy(S,1,I-1);
	S2:=Copy(S,I,(Length(S)-I)+1);
	I1:=StrToInt(S1);
	I2:=StrToInt(S2);
	if not IsPrime(I1+I2) then exit;
	end;
Result:=True;
end;

procedure MagnanimousRange(Memo: TMemo; Start,Stop: integer);
var I,MagCnt,ItemCnt: integer;
var S: string;
begin
S:='';
MagCnt:=0;
ItemCnt:=0;
for I:=0 to High(Integer) do
 if IsMagnanimous(I) then
 	begin
 	Inc(MagCnt);
 	if MagCnt>=Start then
 		begin
 		if MagCnt>Stop then break;
 		S:=S+Format('%12d',[I]);
 		Inc(ItemCnt);
 		if (ItemCnt mod 5)=0 then S:=S+#$0D#$0A;
 		end;
 	end;
Memo.Lines.Add(S);
end;

procedure MagnanimousNumbers(Memo: TMemo);
begin
Memo.Lines.Add('First 45 Magnanimous Numbers');
MagnanimousRange(Memo,0,45);
Memo.Lines.Add('Magnanimous Numbers 241 through 250');
MagnanimousRange(Memo,241,250);
Memo.Lines.Add('Magnanimous Numbers 391 through 400');
MagnanimousRange(Memo,391,400);
end;
