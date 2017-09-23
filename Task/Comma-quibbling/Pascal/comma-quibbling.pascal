program CommaQuibbling;
uses Classes, StrUtils;

const OuterBracket=['[',']'];

type

  { TCommaQuibble }

  TCommaQuibble = class(TStringList)
  private
    function GetCommaquibble: string;
    procedure SetCommaQuibble(AValue: string);
  public
    property CommaQuibble: string read GetCommaquibble write SetCommaQuibble;
  end;

{ TCommaQuibble }

procedure TCommaQuibble.SetCommaQuibble(AValue: string);
begin
  AValue:=ExtractWord(1,AValue,OuterBracket);
  commatext:=Avalue;
end;

function TCommaQuibble.GetCommaquibble: string;
var x: Integer;
    Del: String;
begin
  result:='';
  Del:=', ';
  for x:=0 to Count-1 do
  begin
    result+=Strings[x];
    if x=Count-2 then Del:=' and '
    else if x=count-1 then Del:='';
    result+=del;
  end;
  result:='{'+result+'}';
end;

const TestData: array [0..7] of string=( '[]',
                                         '["ABC"]',
                                         '["ABC", "DEF"]',
                                         '["ABC", "DEF", "G", "H"]',
                                         '',
                                         '"ABC"',
                                         '"ABC", "DEF"',
                                         '"ABC", "DEF", "G", "H"');
var Quibble: TCommaQuibble;
    TestString: String;
begin
  Quibble:=TCommaQuibble.Create;

  for TestString in TestData do
  begin
    Quibble.CommaQuibble:=TestString;
    writeln(Quibble.CommaQuibble);
  end;

end.
