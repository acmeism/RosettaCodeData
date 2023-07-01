program TruthTables;
const
  StackSize = 80;

type
  TVariable = record
    Name: Char;
    Value: Boolean;
  end;

  TStackOfBool = record
    Top: Integer;
    Elements: array [0 .. StackSize - 1] of Boolean;
  end;

var
  Expression: string;
  Variables: array [0 .. 23] of TVariable;
  VariablesLength: Integer;
  i: Integer;
  e: Char;

// Stack manipulation functions
function IsFull(var s: TStackOfBool): Boolean;
begin
  IsFull := s.Top = StackSize - 1;
end;

function IsEmpty(var s: TStackOfBool): Boolean;
begin
  IsEmpty := s.Top = -1;
end;

function Peek(var s: TStackOfBool): Boolean;
begin
  if not IsEmpty(s) then
    Peek := s.Elements[s.Top]
  else
  begin
    Writeln('Stack is empty.');
    Halt;
  end;
end;

procedure Push(var s: TStackOfBool; val: Boolean);
begin
  if not IsFull(s) then
  begin
    Inc(s.Top);
    s.Elements[s.Top] := val;
  end
  else
  begin
    Writeln('Stack is full.');
    Halt;
  end
end;

function Pop(var s: TStackOfBool): Boolean;
begin
  if not IsEmpty(s) then
  begin
    Result := s.Elements[s.Top];
    Dec(s.Top);
  end
  else
  begin
    Writeln;
    Writeln('Stack is empty.');
    Halt;
  end
end;

procedure MakeEmpty(var s: TStackOfBool);
begin
  s.Top := -1;
end;

function ElementsCount(var s: TStackOfBool): Integer;
begin
  ElementsCount := s.Top + 1;
end;

function IsOperator(const c: Char): Boolean;
begin
  IsOperator := (c = '&') or (c = '|') or (c = '!') or (c = '^');
end;

function VariableIndex(const c: Char): Integer;
var
  i: Integer;
begin
  for i := 0 to VariablesLength - 1 do
    if Variables[i].Name = c then
    begin
      VariableIndex := i;
      Exit;
    end;
  VariableIndex := -1;
end;

function EvaluateExpression: Boolean;
var
  i, vi: Integer;
  e: Char;
  s: TStackOfBool;
begin
  MakeEmpty(s);
  for i := 1 to Length(Expression) do
  begin
    e := Expression[i];
    vi := VariableIndex(e);
    if e = 'T' then
      Push(s, True)
    else if e = 'F' then
      Push(s, False)
    else if vi >= 0 then
      Push(s, Variables[vi].Value)
    else
    begin
      {$B+}
      case e of
        '&':
          Push(s, Pop(s) and Pop(s));
        '|':
          Push(s, Pop(s) or Pop(s));
        '!':
          Push(s, not Pop(s));
        '^':
          Push(s, Pop(s) xor Pop(s));
      else
        Writeln;
        Writeln('Non-conformant character ', e, ' in expression.');
        Halt;
      end;
      {$B-}
    end;
  end;
  if ElementsCount(s) <> 1 then
  begin
    Writeln;
    Writeln('Stack should contain exactly one element.');
    Halt;
  end;
  EvaluateExpression := Peek(s);
end;

procedure SetVariables(pos: Integer);
var
  i: Integer;
begin
  if pos > VariablesLength then
  begin
    Writeln;
    Writeln('Argument to SetVariables cannot be greater than the number of variables.');
    Halt;
  end
  else if pos = VariablesLength then
  begin
    for i := 0 to VariablesLength - 1 do
    begin
      if Variables[i].Value then
        Write('T  ')
      else
        Write('F  ');
    end;
    if EvaluateExpression then
      Writeln('T')
    else
      Writeln('F');
  end
  else
  begin
    Variables[pos].Value := False;
    SetVariables(pos + 1);
    Variables[pos].Value := True;
    SetVariables(pos + 1);
  end
end;

// removes space and converts to upper case
procedure ProcessExpression;
var
  i: Integer;
  exprTmp: string;
begin
  exprTmp := '';
  for i := 1 to Length(Expression) do
  begin
    if Expression[i] <> ' ' then
      exprTmp := Concat(exprTmp, UpCase(Expression[i]));
  end;
  Expression := exprTmp
end;

begin
  Writeln('Accepts single-character variables (except for ''T'' and ''F'',');
  Writeln('which specify explicit true or false values), postfix, with');
  Writeln('&|!^ for and, or, not, xor, respectively; optionally');
  Writeln('seperated by space. Just enter nothing to quit.');

  while (True) do
  begin
    Writeln;
    Write('Boolean expression: ');
    ReadLn(Expression);
    ProcessExpression;
    if Length(Expression) = 0 then
      Break;
    VariablesLength := 0;
    for i := 1 to Length(Expression) do
    begin
      e := Expression[i];
      if (not IsOperator(e)) and (e <> 'T') and (e <> 'F') and
        (VariableIndex(e) = -1) then
      begin
        Variables[VariablesLength].Name := e;
        Variables[VariablesLength].Value := False;
        Inc(VariablesLength);
      end;
    end;
    WriteLn;
    if VariablesLength = 0 then
      Writeln('No variables were entered.')
    else
    begin
      for i := 0 to VariablesLength - 1 do
        Write(Variables[i].Name, '  ');
      Writeln(Expression);
      Writeln(StringOfChar('=', VariablesLength * 3 + Length(Expression)));
      SetVariables(0);
    end;
  end;
end.
