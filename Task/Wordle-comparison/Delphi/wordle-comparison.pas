{Structure to hold the secret wordle word and a test word}

type TStringPair = record
 Secret,Test: string;
 end;

{Array of test pairs}

const Pairs: array [0..4] of TStringPair = (
   (Secret: 'ALLOW'; Test: 'LOLLY'),
   (Secret: 'BULLY'; Test: 'LOLLY'),
   (Secret: 'ROBIN'; Test: 'ALERT'),
   (Secret: 'ROBIN'; Test: 'SONIC'),
   (Secret: 'ROBIN'; Test: 'ROBIN'));

{Structures holding wordle colors}

type TWordleColors = (wcGreen,wcYellow,wcGrey);
type TWordleArray = array [0..4] of TWordleColors;


function TestWordle(Secret,Test: string): TWordleArray;
{Compare Test string against secret wordle word}
var I,J,Inx: integer;
var SL: TStringList;

   function LetterAvailable(C: char): boolean;
   {Check to see if letter is unused}
   {Decrement count every time letter used}
   var Inx: integer;
   begin
   Result:=False;
   {Is it in the list?}
   Inx:=SL.IndexOf(C);
   {Exit if not}
   if Inx<0 then exit;
   {Decrement count each time a letter is used}
   SL.Objects[Inx]:=Pointer(Integer(SL.Objects[Inx])-1);
   if integer(SL.Objects[Inx])=0 then SL.Delete(Inx);
   Result:=True;
   end;


begin
SL:=TStringList.Create;
try
{Put letters in list and count number of available}
for I:=1 to Length(Secret) do
   begin
   {Already in list?}
   Inx:=SL.IndexOf(Secret[I]);
   {Store it with a count of 1, if not in list, otherwise, increment count}
   if Inx<0 then SL.AddObject(Secret[I],Pointer(1))
   else SL.Objects[Inx]:=Pointer(Integer(SL.Objects[Inx])+1);
   end;
{Set all words to gray}
for I:=0 to High(Result) do Result[I]:=wcGrey;
{Test for exact position match}
for I:=1 to Length(Test) do
 if Test[I]=Secret[I] then
   begin
   {If we haven't used up the letter, mark it green}
   if LetterAvailable(Test[I]) then Result[I-1]:=wcGreen;
   end;
{Test for non-positional match and mark them yellow}
for I:=1 to Length(Test) do
   begin
   {Check of letter available and not already green}
   if LetterAvailable(Test[I]) then
   if Result[I-1]<>wcGreen then Result[I-1]:=wcYellow;
   end;
finally SL.Free; end;
end;


procedure ShowOneWordle(Memo: TMemo; Pair: TStringPair);
{Test one wordle pair and display result}
var S: string;
var I: integer;
var WA: TWordleArray;
begin
{Get color pattern}
WA:=TestWordle(Pair.Secret,Pair.Test);
{Generate text for color pattern}
S:='';
for I:=0 to High(WA) do
 case WA[I] of
  wcGreen: S:=S+' Green';
  wcYellow: S:=S+' Yellow';
  wcGrey: S:=S+' Gray';
  end;
{Display pair and corresponding color pattern}
Memo.Lines.Add(Pair.Secret+' v '+Pair.Test+': '+S);
end;


procedure ShowWordleColors(Memo: TMemo);
{Show all test pairs}
var I: integer;
begin
for I:=0 to High(Pairs) do
 ShowOneWordle(Memo,Pairs[I]);
end;



