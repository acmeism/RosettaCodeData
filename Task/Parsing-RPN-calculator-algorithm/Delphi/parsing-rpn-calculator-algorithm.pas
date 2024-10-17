{This code normally exists in a library, but is presented here for clarity}

function ExtractToken(S: string; Sep: char; var P: integer): string;
{Extract token from S, starting at P up to but not including Sep}
{Terminates with P pointing past Sep or past end of string}
var C: char;
begin
Result:='';
while P<=Length(S) do
	begin
	C:=S[P]; Inc(P);
	if C=Sep then break
	else Result:=Result+C;
	end;
end;

{Create stack object to handle parsing}

type TRealStack = class(TObject)
 private
  Data: array of double;
  protected
 public
  function GetStackStr: string;
  procedure Push(D: double);
  function Pop: double;
 end;

procedure TRealStack.Push(D: double);
{Push double on stack}
begin
SetLength(Data,Length(Data)+1);
Data[High(Data)]:=D;
end;


function TRealStack.Pop: double;
{Pop double off stack, raises exception if stack empty}
begin
if Length(Data)<1 then raise exception.Create('Stack Empty');
Result:=Data[High(Data)];
SetLength(Data,Length(Data)-1);
end;


function TRealStack.GetStackStr: string;
{Get string representation of stack data}
var I: integer;
begin
Result:='';
for I:=0 to High(Data) do
	begin
	if I<>0 then Result:=Result+', ';
	Result:=Result+FloatToStrF(Data[I],ffGeneral,18,4);
	end;
end;



procedure RPNParser(Memo: TMemo; S: string);
{Parse RPN string and display all operations}
var I: integer;
var Stack: TRealStack;
var Token: string;
var D: double;


	function HandleOperator(S: string): boolean;
	{Handle numerical operator command}
	var Arg1,Arg2: double;
	begin
	Result:=False;
	{Empty comand string? }
	if Length(S)>1 then exit;
	{Invalid command? }
	if not (S[1] in ['+','-','*','/','^']) then exit;
	{Get arguments off stack}
	Arg1:=Stack.Pop; Arg2:=Stack.Pop;
	Result:=True;
	{Decode command}
	case S[1] of
	 '+': Stack.Push(Arg2 + Arg1);
	 '-': Stack.Push(Arg2 - Arg1);
	 '*': Stack.Push(Arg2 * Arg1);
	 '/': Stack.Push(Arg2 / Arg1);
	 '^': Stack.Push(Power(Arg2,Arg1));
	 else Result:=False;
	 end;
	end;


begin
Stack:=TRealStack.Create;
try
I:=1;
while true do
	begin
	{Extract one token from string}
	Token:=ExtractToken(S,' ',I);
	{Exit if no more data}
	if Token='' then break;
	{If token is a number convert it to a double otherwise, process an operator}
	if Token[1] in ['0'..'9'] then Stack.Push(StrToFloat(Token))
	else if not HandleOperator(Token) then raise Exception.Create('Illegal Token: '+Token);
	Memo.Lines.Add(Token+' ['+Stack.GetStackStr+']');
	end;
finally Stack.Free; end;
end;


procedure ShowRPNParser(Memo: TMemo);
var S: string;
begin
S:='3 4 2 * 1 5 - 2 3 ^ ^ / + ';
RPNParser(Memo,S);
end;
