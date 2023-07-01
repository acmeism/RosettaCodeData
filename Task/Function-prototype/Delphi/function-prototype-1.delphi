program Function_prototype;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TIntArray = TArray<Integer>;

  TIntArrayHelper = record helper for TIntArray
    const
      DEFAULT_VALUE = -1;
    // A prototype declaration for a function that does not require arguments
    function ToString(): string;

    // A prototype declaration for a function that requires two arguments
    procedure Insert(Index: Integer; value: Integer);

    // A prototype declaration for a function that utilizes varargs
    // varargs is not available, but a equivalent is array of const
    procedure From(Args: array of const);

    //A prototype declaration for a function that utilizes optional arguments
    procedure Delete(Index: Integer; Count: Integer = 1);

    //A prototype declaration for a function that utilizes named parameters
    // Named parameters is not supported in Delphi

    //Example of prototype declarations for subroutines or procedures
    //(if these differ from functions)
    procedure Sqr;    //Procedure return nothing
    function Averange: double; //Function return a value
  end;

{ TIntHelper }

function TIntArrayHelper.Averange: double;
begin
  Result := 0;
  for var e in self do
    Result := Result + e;
  Result := Result / Length(self);
end;

procedure TIntArrayHelper.Delete(Index, Count: Integer);
begin
  System.Delete(self, Index, Count);
end;

procedure TIntArrayHelper.From(Args: array of const);
var
  I, Count: Integer;
begin
  Count := Length(Args);
  SetLength(self, Count);

  if Count = 0 then
    exit;
  for I := 0 to High(Args) do
    with Args[I] do
      case VType of
        vtInteger:
          self[I] := VInteger;
        vtBoolean:
          self[I] := ord(VBoolean);
        vtChar, vtWideChar:
          self[I] := StrToIntDef(string(VChar), DEFAULT_VALUE);
        vtExtended:
          self[I] := Round(VExtended^);
        vtString:
          self[I] := StrToIntDef(VString^, DEFAULT_VALUE);
        vtPChar:
          self[I] := StrToIntDef(VPChar, DEFAULT_VALUE);
        vtObject:
          self[I] := cardinal(VObject);
        vtClass:
          self[I] := cardinal(VClass);
        vtAnsiString:
          self[I] := StrToIntDef(string(VAnsiString), DEFAULT_VALUE);
        vtCurrency:
          self[I] := Round(VCurrency^);
        vtVariant:
          self[I] := Integer(VVariant^);
        vtInt64:
          self[I] := Integer(VInt64^);
        vtUnicodeString:
          self[I] := StrToIntDef(string(VUnicodeString), DEFAULT_VALUE);
      end;
end;

procedure TIntArrayHelper.Insert(Index, value: Integer);
begin
  system.Insert([value], self, Index);
end;

procedure TIntArrayHelper.Sqr;
begin
  for var I := 0 to High(self) do
    Self[I] := Self[I] * Self[I];
end;

function TIntArrayHelper.ToString: string;
begin
  Result := '[';
  for var e in self do
    Result := Result + e.ToString + ', ';
  Result := Result + ']';
end;

begin
  var val: TArray<Integer>;
  val.From([1, '2', PI]);
  val.Insert(0, -1); // insert -1 at position 0
  writeln('  Array:    ', val.ToString, ' ');
  writeln('  Averange: ', val.Averange: 3: 2);
  val.Sqr;
  writeln('  Sqr:      ', val.ToString);
  Readln;

end.
