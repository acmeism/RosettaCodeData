{This code would normally be in a library somewhere, but it is included here for clarity}

{TKeywaiter interface}

type TKeyWaiter = class(TObject)
 private
  FControl: TWinControl;
  FControlCAbort: boolean;
 protected
  procedure HandleKeyPress(Sender: TObject; var Key: Char);
 public
  KeyChar: Char;
  ValidKey: boolean;
  AbortWait: boolean;
  constructor Create(Control: TWinControl);
  function WaitForKey: char;
  function WaitForInteger: integer;
  function WaitForReal: double;
  property ControlCAbort: boolean read FControlCAbort write FControlCAbort;
 end;


{ TMemoWaiter implementation }

type TControlHack = class(TWinControl) end;

constructor TKeyWaiter.Create(Control: TWinControl);
{Save the control we want to wait on}
begin
FControl:=Control;
FControlCAbort:=False;
end;

procedure TKeyWaiter.HandleKeyPress(Sender: TObject; var Key: Char);
{Handle captured key press}
begin
KeyChar:=Key;
ValidKey:=True;
if ControlCAbort then AbortWait:=KeyChar = #$03;
end;


function TKeyWaiter.WaitForKey: char;
{Capture keypress event and wait for key press control}
{Spends most of its time sleep and aborts if the user}
{sets the abort flag or the program terminates}
begin
ValidKey:=False;
AbortWait:=False;
TControlHack(FControl).OnKeyPress:=HandleKeyPress;
repeat
	begin
	Application.ProcessMessages;
	Sleep(100);
	end
until ValidKey or Application.Terminated or AbortWait;
Result:=KeyChar;
end;


function TKeyWaiter.WaitForInteger: integer;
var C: char;
var S: string;
begin
Result:=0;
S:='';
{Wait for first numeric characters}
repeat
	begin
	C:=WaitForKey;
	if AbortWait or Application.Terminated then exit;
	end
until C in ['+','-','0'..'9'];
{Read characters and convert to}
{integer until non-integer arrives}
repeat
	begin
	S:=S+C;
	C:=WaitForKey;
	if AbortWait or Application.Terminated then exit;
	end
until not (C in  ['+','-','0'..'9']);
Result:=StrToInt(S);
end;


type TCharSet = set of char;

function TKeyWaiter.WaitForReal: double;
var C: char;
var S: string;
const RealSet: TCharSet = ['-','+','.','0'..'9'];
begin
Result:=0;
S:='';
{Wait for first numeric characters}
repeat
	begin
	C:=WaitForKey;
	if AbortWait or Application.Terminated then exit;
	end
until C in RealSet;
{Read characters and convert to}
{integer until non-integer arrives}
repeat
	begin
	S:=S+C;
	C:=WaitForKey;
	if AbortWait or Application.Terminated then exit;
	end
until not (C in RealSet);
Result:=StrToFloat(S);
end;



{===========================================================}


function WaitForReal(Memo: TMemo; Prompt: string): double;
{Wait for double entered into TMemo component}
var KW: TKeyWaiter;
begin
{Use custom object to wait for and capture reals}
KW:=TKeyWaiter.Create(Memo);
try
Memo.Lines.Add(Prompt);
Memo.SelStart:=Memo.SelStart-1;
Memo.SetFocus;
Result:=KW.WaitForReal;
finally KW.Free; end;
end;

var Count: integer;
var Average: double;

procedure RecurringRainfall(Memo: TMemo);
var D: double;
begin
Count:=0;
Average:=0;
while true do
	begin
	D:=WaitForReal(Memo,'Enter integer rainfall (99999 to quit): ');
	if Application.Terminated then exit;
	if (Trunc(D)<>D) or (D<0) then
		begin
		Memo.Lines.Add('Must be integer >=0');
		continue;
		end;
	if D=99999 then break;
	Inc(Count);
	Average := Average + (1 / Count) * D - (1 / Count)*Average;
	Memo.Lines.Add('New Average: '+FloatToStrF(Average,ffFixed,18,2));
	end;
end;
