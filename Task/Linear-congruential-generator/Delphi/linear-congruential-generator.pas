program Linear_congruential_generator;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows;

type
  TRandom = record
  private
    FSeed: Cardinal;
    FBsdCurrent: Cardinal;
    FMsvcrtCurrent: Cardinal;
    class function Next(seed, a, b: Cardinal): Cardinal; static;
  public
    constructor Create(const seed: Cardinal);
    function Rand(Bsd: Boolean = True): Cardinal;
    property Seed: Cardinal read FSeed;
  end;

{ TRandom }

class function TRandom.Next(seed, a, b: Cardinal): Cardinal;
begin
  Result := (a * seed + b) and MAXDWORD;
end;

function TRandom.Rand(Bsd: Boolean): Cardinal;
begin
  if Bsd then
  begin
    FBsdCurrent := Next(FBsdCurrent, 1103515245, 12345);
    Result := FBsdCurrent;
  end
  else
  begin
    FMsvcrtCurrent := Next(FMsvcrtCurrent shl 16, 214013, 2531011) shr 16;
    Result := FMsvcrtCurrent;
  end;
end;

constructor TRandom.Create(const seed: Cardinal);
begin
  FSeed := seed;
  FBsdCurrent := FSeed;
  FMsvcrtCurrent := FSeed;
end;

var
  r: TRandom;

procedure PrintRandom(count: Integer; IsBsd: Boolean);
const
  NAME: array[Boolean] of string = ('MS', 'BSD');
var
  i: Integer;
begin
  Writeln(NAME[IsBsd], ' next ', count, ' Random'#10);
  for i := 0 to count - 1 do
    writeln('   ', r.Rand(IsBsd));
  writeln;
end;

begin
  r.Create(GetTickCount);
  PrintRandom(10, True);
  PrintRandom(10, False);
  readln;
end.
