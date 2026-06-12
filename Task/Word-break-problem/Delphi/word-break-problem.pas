program Word_break_problem;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TDict = TDictionary<string, boolean>;

  TPrefix = record
    length: integer;
    broken: TArray<string>;
    constructor Create(len: integer; b: TArray<string>);
  end;

const
  TESTS: TArray<string> = ['abcd', 'abbc', 'abcbcd', 'acdbc', 'abcdd'];

var
  d: TDict;

function newDict(words: TArray<string>): TDict;
var
  w: string;
begin
  Result := TDict.Create();
  for w in words do
    Result.AddOrSetValue(w, true);
end;

function wordBreak(s: string; var broken: TArray<string>): boolean;
var
  ed, i: Integer;
  w: string;
  p: TPrefix;
  bp: TArray<TPrefix>;
begin
  SetLength(broken, 0);

  if s.IsEmpty then
    exit(true);

  bp := [TPrefix.Create(0, [])];

  for ed := 1 to s.Length do
    for i := High(bp) downto 0 do
    begin

      w := s.Substring(bp[i].length, ed - bp[i].length);
      if d.ContainsKey(w) then
      begin
        broken := bp[i].broken + [w];
        if ed = s.Length then
          exit(true);
        p := TPrefix.Create(ed, broken);
        bp := bp + [p];
        Break;
      end;
    end;
  Result := false;
end;

{ TPrefix }

constructor TPrefix.Create(len: integer; b: TArray<string>);
begin
  broken := b;
  length := len;
end;

var
  s: string;
  b: TArray<string>;
  ok: boolean;

begin
  d := newDict(['a', 'bc', 'abc', 'cd', 'b']);
  for s in TESTS do
    if wordBreak(s, b) then
      Writeln(Format('%s: %s', [s, string.join(' ', b)]))
    else
      Writeln('can''t break');
  d.Free;

  Readln;
end.
