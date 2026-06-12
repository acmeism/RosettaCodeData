{------- These subroutines would normally be in libraries, but they are included here for clairty------------- }

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


function GetNextPrime(Start: integer): integer;
{Get the next prime number after Start}
begin
repeat Inc(Start)
until IsPrime(Start);
Result:=Start;
end;

{-----------------------------------------------------------------------------------------------------}


type TPrimeInfo = record
 Prime1,Prime2: integer;
 Count: integer;
 end;

type TOrmIterator = class(TObject)
  Info: TPrimeInfo;
 private
  function IsOrmistonPair(P1, P2: integer): boolean;
 protected
 public
  procedure Reset;
  function GetNext: TPrimeInfo;
 end;


function TOrmIterator.IsOrmistonPair(P1,P2: integer): boolean;
{Tests if P1 and P2 primes represent Ormiston Pairs}
{I}
var S1,S2: string;
var I,J: integer;
var SL1,SL2: TStringList;
begin
Result:=False;
SL1:=TStringList.Create;
SL2:=TStringList.Create;
try
{Copy characters in numbers into string lists}
SL1.Duplicates:=dupAccept;
SL2.Duplicates:=dupAccept;
S1:=IntToStr(P1); S2:=IntToStr(P2);
for I:=1 to Length(S1) do SL1.Add(S1[I]);
for I:=1 to Length(S2) do SL2.Add(S2[I]);
{Sort them }
SL1.Sort; SL2.Sort;
{And compare them item for item - any mismatch = not Ormiston Pair }
for I:=0 to Min(SL1.Count,SL2.Count)-1 do
 if SL1[I]<>SL2[I] then exit;
Result:=True;
finally Sl1.Free; SL2.Free; end;
end;


procedure TOrmIterator.Reset;
{Restart iterator}
begin
Info.Count:=0;
Info.Prime1:=1; Info.Prime2:=3;
end;


function TOrmIterator.GetNext: TPrimeInfo;
{Iterate to next Ormiston Pair}
begin
while true do
	begin
	Info.Prime2:=GetNextPrime(Info.Prime1);
	if IsOrmistonPair(Info.Prime1,Info.Prime2) then
		begin
		Inc(Info.Count);
		Result:=Info;
		Info.Prime1:=Info.Prime2;
		break;
		end
	else Info.Prime1:=Info.Prime2;
	end;
end;


procedure ShowOrmistonPairs(Memo: TMemo);
var I: integer;
var S: string;
var OI: TOrmIterator;
var Info: TPrimeInfo;
begin
{Create iterator}
OI:=TOrmIterator.Create;
try
OI.Reset;
{Iterate throug 1st 30 pairs}
for I:=1 to 30 do
	begin
	Info:=OI.GetNext;
	S:=S+Format('(%6D %6D) ',[Info.Prime1,Info.Prime2]);
	If (Info.Count mod 3)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Info.Count));

{iterate to millionth pair}
repeat Info:=OI.GetNext
until Info.Prime2>=1000000;
Memo.Lines.Add('1000,000 ='+IntToStr(Info.Count-1));
{iterate to 10 millionth pair}
repeat Info:=OI.GetNext
until Info.Prime2>=10000000;
Memo.Lines.Add('10,000,000 ='+IntToStr(Info.Count-1));
finally OI.Free; end;
end;

