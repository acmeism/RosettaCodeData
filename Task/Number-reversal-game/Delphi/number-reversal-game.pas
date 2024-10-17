type TKeyWaiter = class(TObject)
 private
  FControl: TWinControl;
 protected
  procedure HandleKeyPress(Sender: TObject; var Key: Char);
 public
  KeyChar: Char;
  ValidKey: boolean;
  Abort: boolean;
  constructor Create(Control: TWinControl);
  function WaitForKey: char;
 end;

{ TMemoWaiter }

type TControlHack = class(TWinControl) end;

constructor TKeyWaiter.Create(Control: TWinControl);
{Save the control we want to wait on}
begin
FControl:=Control;
end;

procedure TKeyWaiter.HandleKeyPress(Sender: TObject; var Key: Char);
{Handle captured key press}
begin
KeyChar:=Key;
ValidKey:=True;
end;


function TKeyWaiter.WaitForKey: char;
{Capture keypress event and wait for key press control}
{Spends most of its time sleep and aborts if the user}
{sets the abort flag or the program terminates}
begin
ValidKey:=False;
Abort:=False;
TControlHack(FControl).OnKeyPress:=HandleKeyPress;
repeat
	begin
	Application.ProcessMessages;
	Sleep(100);
	end
until ValidKey or Application.Terminated or Abort;
Result:=KeyChar;
end;




{===========================================================}

type TNumbers = array [0..8] of integer;

function WaitForKey(Memo: TMemo; Prompt: string): char;
{Wait for key stroke on TMemo component}
var KW: TKeyWaiter;
begin
{Use custom object to wait and capture key strokes}
KW:=TKeyWaiter.Create(Memo);
try
Memo.Lines.Add(Prompt);
Memo.SelStart:=Memo.SelStart-1;
Memo.SetFocus;
Result:=KW.WaitForKey;
finally KW.Free; end;
end;


procedure ScrambleNumbers(var Numbers: TNumbers);
{Scramble numbers into a random order}
var I,I1,I2,T: integer;
begin
for I:=0 to 8 do Numbers[I]:=I+1;
for I:=1 to 100 do
	begin
	I1:=Random(9);
	I2:=Random(9);
	T:=Numbers[I1];
	Numbers[I1]:=Numbers[I2];
	Numbers[I2]:=T;
	end;
end;

function GetNumbersStr(Numbers: TNumbers): string;
{Return number order as a string}
var I: integer;
begin
Result:='';
for I:=0 to High(Numbers) do
	begin
	if I<>0 then Result:=Result+' ';
	Result:=Result+IntToStr(Numbers[I]);
	end;
end;


procedure ReverseNumbers(var Numbers: TNumbers; Count: integer);
{Reverse the specified count of numbers from the start}
var NT: TNumbers;
var I,I1: integer;
begin
NT:=Numbers;
for I:=0 to Count-1 do
	begin
	I1:=(Count-1) - I;
	Numbers[I1]:=NT[I];
	end;
end;

function IsWinner(Numbers: TNumbers): boolean;
{Check if is number is order 1..9}
var I: integer;
begin
Result:=False;
for I:=0 to High(Numbers) do
 if Numbers[I]<>(I+1) then exit;
Result:=True;
end;

procedure ReverseGame(Memo: TMemo);
{Play the reverse game on specified memo}
var C: char;
var Numbers: TNumbers;
var S: string;
var R: integer;
begin
Randomize;
ScrambleNumbers(Numbers);
while true do
	begin
	S:=GetNumbersStr(Numbers);
	C:=WaitForKey(Memo,S+' Number To Reverse: ');
	if Application.Terminated then exit;
	if C in ['x','X'] then break;
	R:=byte(C) - $30;
	ReverseNumbers(Numbers,R);
	if IsWinner(Numbers) then
		begin
		S:=GetNumbersStr(Numbers);
		Memo.Lines.Add(S+' - WINNER!!');
		break;
		end;
	end;
end;
