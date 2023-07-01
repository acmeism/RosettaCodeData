program Chinese_zodiac;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Math;

type
  TElements = array of array of char;

  TChineseZodiac = record
    Year: Integer;
    Yyear: string;
    Animal: string;
    Element: string;
    AnimalChar: char;
    ElementChar: char;
    procedure Assign(aYear: Integer);
    function ToString: string;
  end;

const
  animals: TArray<string> = ['Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake',
    'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig'];
  elements: TArray<string> = ['Wood', 'Fire', 'Earth', 'Metal', 'Water'];
  animalChars: TArray<char> = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉',
    '戌', '亥'];
  elementChars: TElements = [['甲', '丙', '戊', '庚', '壬'], ['乙', '丁', '己', '辛', '癸']];


function getYY(year: Integer): string;
begin
  if (year mod 2) = 0 then
  begin
    Exit('yang');
  end;
  Exit('yin');
end;

{ TChineseZodiac }

procedure TChineseZodiac.Assign(aYear: Integer);
var
  ei, ai: Integer;
begin
  ei := Trunc(Floor((Trunc(aYear - 4.0) mod 10) / 2));
  ai := (aYear - 4) mod 12;
  year := aYear;
  Element := elements[ei];
  Animal := animals[ai];
  ElementChar := elementChars[aYear mod 2, ei];
  AnimalChar := animalChars[(aYear - 4) mod 12];
  Yyear := getYY(aYear);
end;

var
  z: TChineseZodiac;
  years: TArray<Integer> = [1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017];
  year: integer;

function TChineseZodiac.ToString: string;
begin
  Result := Format('%d is the year of the %s %s (%s). %s%s', [year, Element,
    Animal, Yyear, ElementChar, AnimalChar]);
end;

var
  Outfile: TextFile;
  Written: Cardinal;

begin
  SetConsoleOutputCP(CP_UTF8);

  AssignFile(Outfile, 'Output.txt', CP_UTF8);
  Rewrite(Outfile);

  for year in years do
  begin
    z.Assign(year);
    Writeln(Outfile, z.ToString);
    Writeln(z.ToString);
  end;

  CloseFile(Outfile);
  Readln;
end.
