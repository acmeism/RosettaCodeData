program Textonyms;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Character;

const
  TEXTONYM_MAP = '22233344455566677778889999';

type
  TextonymsChecker = class
  private
    Total, Elements, Textonyms, MaxFound: Integer;
    MaxStrings: TList<string>;
    Values: TDictionary<string, TList<string>>;
    FFileName: TFileName;
    function Map(c: Char): Char;
    function GetMapping(var return: string; const Input: string): Boolean;
  public
    constructor Create(FileName: TFileName);
    destructor Destroy; override;
    procedure Add(const Str: string);
    procedure Load(FileName: TFileName);
    procedure Test;
    function Match(const str: string): Boolean;
    property FileName: TFileName read FFileName;
  end;

{ TextonymsChecker }

procedure TextonymsChecker.Add(const Str: string);
var
  mapping: string;
  num_strings: Integer;

  procedure AddValues(mapping: string; NewItem: string);
  begin
    if not Values.ContainsKey(mapping) then
      Values.Add(mapping, TList<string>.Create);

    Values[mapping].Add(NewItem);
  end;

begin
  inc(total);

  if not GetMapping(mapping, Str) then
    Exit;

  if Values.ContainsKey(mapping) then
    num_strings := Values[mapping].Count
  else
    num_strings := 0;

  inc(Textonyms, ord(num_strings = 1));
  inc(Elements);

  if (num_strings > maxfound) then
  begin
    MaxStrings.Clear;
    MaxStrings.Add(mapping);
    MaxFound := num_strings;
  end
  else if num_strings = MaxFound then
  begin
    MaxStrings.Add(mapping);
  end;

  AddValues(mapping, Str);
end;

constructor TextonymsChecker.Create(FileName: TFileName);
begin
  MaxStrings := TList<string>.Create;
  Values := TDictionary<string, TList<string>>.Create;
  Total := 0;
  Textonyms := 0;
  MaxFound := 0;
  Elements := 0;
  Load(FileName);
end;

destructor TextonymsChecker.Destroy;
var
  key: string;
begin
  for key in Values.Keys do
    Values[key].Free;

  Values.Free;
  MaxStrings.Free;
  inherited;
end;

function TextonymsChecker.GetMapping(var return: string; const Input: string): Boolean;
var
  i: Integer;
begin
  return := Input;
  for i := 1 to return.Length do
  begin
    if not return[i].IsLetterOrDigit then
      exit(False);

    if return[i].IsLetter then
      return[i] := Map(return[i]);
  end;
  Result := True;
end;

procedure TextonymsChecker.Load(FileName: TFileName);
var
  i: Integer;
begin
  if not FileExists(FileName) then
  begin
    writeln('File "', FileName, '" not found');
    exit;
  end;

  with TStringList.Create do
  begin
    LoadFromFile(FileName);
    for i := 0 to count - 1 do
    begin
      self.Add(Strings[i]);
    end;
    Free;
  end;
end;

function TextonymsChecker.Map(c: Char): Char;
begin
  Result := TEXTONYM_MAP.Chars[Ord(UpCase(c)) - Ord('A')];
end;

function TextonymsChecker.Match(const str: string): Boolean;
var
  w: string;
begin
  Result := Values.ContainsKey(str);

  if not Result then
  begin
    writeln('Key "', str, '" not found');
  end
  else
  begin
    write('Key "', str, '" matches: ');
    for w in Values[str] do
    begin
      write(w, ' ');
    end;
    writeln;
  end;
end;

procedure TextonymsChecker.Test;
var
  i, j: Integer;
begin
  writeln('Read ', Total, ' words from ', FileName, #10);
  writeln(' which can be represented by the digit key mapping.');
  writeln('They require ', Values.Count, ' digit combinations to represent them.');
  writeln(textonyms, ' digit combinations represent Textonyms.', #10);
  write('The numbers mapping to the most words map to');
  writeln(MaxFound + 1, ' words each:');

  for i := 0 to MaxStrings.Count - 1 do
  begin
    write(^I, MaxStrings[i], ' maps to: ');
    for j := 0 to Values[MaxStrings[i]].Count - 1 do
    begin
      write(Values[MaxStrings[i]][j], ' ');
    end;
    Writeln;
  end;

end;

var
  Tc: TextonymsChecker;

begin
  Tc := TextonymsChecker.Create('unixdict.txt');
  Tc.Test;

  tc.match('001');
  tc.match('228');
  tc.match('27484247');
  tc.match('7244967473642');

  Tc.Free;
  readln;
end.
