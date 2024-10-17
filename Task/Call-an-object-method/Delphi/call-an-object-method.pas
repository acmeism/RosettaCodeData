{Simple stack interface}

type TSimpleStack = class(TObject)
 private
  FStack: array of integer;
 protected
 public
  procedure Push(I: integer);
  function Pop(var I: integer): boolean;
  constructor Create;
 end;


{ TSimpleStack implementation }

constructor TSimpleStack.Create;
{Initialize stack by setting size to zero}
begin
SetLength(FStack,0);
end;

function TSimpleStack.Pop(var I: integer): boolean;
{Pop top item off stack into "I" returns False if stack empty}
begin
Result:=Length(FStack)>=1;
if Result then
	begin
	{Get item from top of stack}
	I:=FStack[High(FStack)];
	{Delete the top item}
	SetLength(FStack,Length(FStack)-1);
	end;
end;

procedure TSimpleStack.Push(I: integer);
{Push item on stack by adding to end of array}
begin
{Increase stack size by one}
SetLength(FStack,Length(FStack)+1);
{Insert item}
FStack[High(FStack)]:=I;
end;


procedure ShowStaticMethodCall(Memo: TMemo);
var Stack: TSimpleStack;	{Declare stack object}
var I: integer;
begin
{Instanciate stack object}
Stack:=TSimpleStack.Create;
{Push items on stack by calling static method "Push"}
for I:=1 to 10 do Stack.Push(I);
{Call static method "Pop" to retrieve and display stack items}
while Stack.Pop(I) do
	begin
	Memo.Lines.Add(IntToStr(I));
	end;
{release stack memory and delete object}
Stack.Free;
end;
