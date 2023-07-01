var ErrorFlag: boolean;
var ErrorStr: string;


function EvaluateExpression(Express: string): double;
{ Recursive descent expression evaluator }
var Atom: char;
var ExpressStr: string;
var ExpressInx: integer;
const Tab_Char = #$09; SP_char = #$20;

	procedure HandleError(S: string);
	begin
	ErrorStr:=S;
	ErrorFlag:=True;
	Abort;
	end;


	procedure GetChar;
	begin
	if ExpressInx > Length(ExpressStr) then
		begin
		Atom:= ')';
		end
	 else	begin
		Atom:= ExpressStr[ExpressInx];
		Inc(ExpressInx);
		end;
	end;



	procedure SkipWhiteSpace;
	{ Skip Tabs And Spaces In Expression }
	begin
	while (Atom=TAB_Char) or (Atom=SP_char) do GetChar;
	end;



	procedure SkipSpaces;
	{ Get Next Character, Ignoring Any Space Characters }
	begin
	repeat GetChar until Atom <> SP_CHAR;
	end;



	function GetDecimal: integer;
	{ Read In A Decimal String And Return Its Value }
	var S: string;
	begin
	Result:=0;
	S:='';
	while True do
		begin
		if not (Atom in ['0'..'9']) then break;
		S:=S+Atom;
		GetChar;
		end;
	if S='' then HandleError('Number Expected')
	else Result:=StrToInt(S);
	if Result>9 then HandleError('Only Numbers 0..9 allowed')
	end;


	function Expression: double;
	{ Returns The Value Of An Expression }



		function Factor: double;
		{ Returns The Value Of A Factor }
		var NEG: boolean;
		begin
		Result:=0;
		while Atom='+' do SkipSpaces;		{ Ignore Unary "+" }
		NEG:= False;
		while Atom ='-' do			{ Unary "-" }
			begin
			SkipSpaces;
			NEG:= not NEG;
			end;

		if (Atom>='0') and (Atom<='9') then Result:= GetDecimal	{ Unsigned Integer }
		else case Atom of
		  '(':	begin				{ Subexpression }
			SkipSpaces;
			Result:= Expression;
			if Atom<>')' then HandleError('Mismatched Parenthesis');
			SkipSpaces;
			end;
		  else	HandleError('Syntax Error');
		  end;
		{ Numbers May Terminate With A Space Or Tab }
		SkipWhiteSpace;
		if NEG then Result:=-Result;
		end;	{ Factor }



		function Term: double;
		{ Returns Factor * Factor, Etc. }
		var R: double;
		begin
		Result:= Factor;
		while True do
			case Atom of
			  '*':	begin
			  	SkipSpaces;
			  	Result:= Result * Factor;
			  	end;
			  '/':	begin
			  	SkipSpaces;
			  	R:=Factor;
			  	if R=0 then HandleError('Divide By Zero');
			  	Result:= Result / R;
			  	end;
			  else	break;
			end;
		end;
		{ Term }



		function AlgebraicExpression: double;
		{ Returns Term + Term, Etc. }
		begin
		Result:= Term;
		while True do
			case Atom of
			  '+':	begin SkipSpaces; Result:= Result + Term; end;
			  '-':	begin SkipSpaces; Result:= Result - Term; end
			else	break;
			end;
		end; { Algexp }



	begin	{ Expression }
	SkipWhiteSpace;
	Result:= AlgebraicExpression;
	end;	{ Expression }



begin	{ EvaluateExpression }
ErrorFlag:=False;
ErrorStr:='';
ExpressStr:=Express;
ExpressInx:=1;
try
GetChar;
Result:= Expression;
except end;
end;


function WaitForString(Memo: TMemo; Prompt: string): string;
{Wait for key stroke on TMemo component}
var MW: TMemoWaiter;
var C: char;
var Y: integer;
begin
{Use custom object to wait and capture key strokes}
MW:=TMemoWaiter.Create(Memo);
try
Memo.Lines.Add(Prompt);
Memo.SelStart:=Memo.SelStart-1;
Memo.SetFocus;
Result:=MW.WaitForLine;
finally MW.Free; end;
end;





procedure Play24Game(Memo: TMemo);
{Play the 24 game}
var R: double;
var Nums: array [0..4-1] of char;
var I: integer;
var Express,RS: string;
var RB: boolean;

	procedure GenerateNumbers;
	{Generate and display four random number 1..9}
	var S: string;
	var I: integer;
	begin
	{Generate random numbers}
	for I:=0 to High(Nums) do
	 Nums[I]:=char(Random(9)+$31);
	{Display them}
	S:='';
	for I:=0 to High(Nums) do
	 S:=S+' '+Nums[I];
	Memo.Lines.Add('Your Digits: '+S);
	end;

	function TestMatchingNums: boolean;
	{Make sure numbers entered by user match the target numbers}
	var SL1,SL2: TStringList;
	var I: integer;
	begin
	Result:=False;
	SL1:=TStringList.Create;
	SL2:=TStringList.Create;
	try
	{Load target numbers into string list}
	for I:=0 to High(Nums) do SL1.Add(Nums[I]);
	{Load users expression number int string list}
	for I:=1 to Length(Express) do
	 if Express[I] in ['0'..'9'] then SL2.Add(Express[I]);
	{There should be the same number }
	if SL1.Count<>SL2.Count then exit;
	{Sort them to facilitate testing}
	SL1.Sort; SL2.Sort;
	{Are number identical, if not exit}
	for I:=0 to SL1.Count-1 do
	 if SL1[I]<>SL2[I] then exit;
	{Users numbers passed all tests}
	Result:=True;
	finally
	 SL2.Free;
	 SL1.Free;
	 end;
	end;

	function TestUserExpression(var S: string): boolean;
	{Test expression user entered }
	begin
	Result:=False;
	if not TestMatchingNums then
		begin
		S:='Numbers Do not Match';
		exit;
		end;

	R:=EvaluateExpression(Express);
	S:='Expression Value = '+FloatToStrF(R,ffFixed,18,0)+CRLF;
	if ErrorFlag then
		begin
		S:=S+'Expression Problem: '+ErrorStr;
		exit;
		end;
	if R<>24 then
		begin
		S:=S+'Expression is incorrect value';
		exit;
		end;
	S:=S+'!!!!!! Winner !!!!!!!';
	Result:=True;
	end;


begin
Randomize;
Memo.Lines.Add('=========== 24 Game ===========');
GenerateNumbers;
while true do
	begin
	if Application.Terminated then exit;
	Express:=WaitForString(Memo,'Enter expression, Q = quit, N = New numbers: '+CRLF);
	if Pos('N',UpperCase(Express))>0 then
		begin
		GenerateNumbers;
		Continue;
		end;
	if Pos('Q',UpperCase(Express))>0 then exit;
	RB:=TestUserExpression(RS);
	Memo.Lines.Add(RS);
	if not RB then continue;
	RS:=WaitForString(Memo,'Play again Y=Yes, N=No'+CRLF);
	if Pos('N',UpperCase(RS))>0 then exit;
	GenerateNumbers;
	end;
end;
