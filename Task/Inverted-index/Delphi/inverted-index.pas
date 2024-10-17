program Inverted_index;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  system.Generics.Collections,
  SYstem.IOUtils;

type
  TIndex = class
  private
    FFileNames: TArray<string>;
    FIndexs: TDictionary<string, string>;
    class function SplitWords(Text: string): TArray<string>; static;
    function StoreFileName(FileName: TFileName): string;
    procedure StoreLine(Line, Id: string);
    procedure StoreWord(aWord, Id: string);
    function DecodeFileName(Indexed: string): string;
  public
    procedure AddFile(FileName: TFileName);
    constructor Create;
    destructor Destroy; override;
    function Search(aWord: string): string;
    property Index[aWord: string]: string read Search; default;
  end;

{ TIndex }

constructor TIndex.Create;
begin
  FIndexs := TDictionary<string, string>.Create();
  SetLength(FFileNames, 0);
end;

function TIndex.DecodeFileName(Indexed: string): string;
var
  f: string;
  i: integer;
begin
  Result := Indexed;
  if Length(FFileNames) > 0 then
    for i := 0 to High(FFileNames) do
    begin
      f := FFileNames[i];
      Result := Result.Replace(format('(%x)', [i]), f);
    end;
end;

destructor TIndex.Destroy;
begin
  FIndexs.Free;
  inherited;
end;

function TIndex.Search(aWord: string): string;
begin
  aWord := AnsiLowerCase(aWord);
  if FIndexs.ContainsKey(aWord) then
    Result := 'found in ' + DecodeFileName(FIndexs[aWord])
  else
    Result := 'not found';
end;

class function TIndex.SplitWords(Text: string): TArray<string>;
const
  WORD_CHARSET: set of char = (['a'..'z', 'A'..'Z', 'á', 'é', 'í', 'ó', 'ú', 'ã',
    'õ', 'à', 'è', 'ì', 'ò', 'ù', 'Á', 'É', 'Í', 'Ó', 'Ú', 'Ã', 'Õ', 'À', 'È',
    'Ì', 'Ò', 'Ù', 'ä', 'ë', 'ï', 'ö', 'ü', 'ç', 'Ç', '_', '0'..'9']);

  procedure Append(var value: string);
  begin
    if not value.IsEmpty then
    begin
      SetLength(result, length(result) + 1);
      result[high(result)] := value;
      value := '';
    end;
  end;

var
  c: Char;
  inWord, isWordChar: boolean;
  w: string;
begin
  inWord := False;
  w := '';
  SetLength(result, 0);
  for c in Text do
  begin
    isWordChar := (c in WORD_CHARSET);
    if inWord then
      if isWordChar then
        w := w + c
      else
      begin
        Append(w);
        inWord := false;
        Continue;
      end;

    if not inWord and isWordChar then
    begin
      inWord := True;
      w := c;
    end;
  end;
  if inWord then
    Append(w);
end;

function TIndex.StoreFileName(FileName: TFileName): string;
begin
  SetLength(FFileNames, length(FFileNames) + 1);
  FFileNames[High(FFileNames)] := FileName;
  Result := format('"(%x)"', [High(FFileNames)]);
end;

procedure TIndex.StoreLine(Line, Id: string);
var
  Words: TArray<string>;
  w: string;
begin
  Words := SplitWords(Line);
  for w in Words do
    StoreWord(w, Id);
end;

procedure TIndex.StoreWord(aWord, Id: string);
begin
  aWord := AnsiLowercase(aWord);
  if FIndexs.ContainsKey(aWord) then
  begin
    if (FIndexs[aWord].IndexOf(Id) = -1) then
      FIndexs[aWord] := FIndexs[aWord] + ', ' + Id;
  end
  else
    FIndexs.Add(aWord, Id);
end;

procedure TIndex.AddFile(FileName: TFileName);
var
  Lines: TArray<string>;
  Line: string;
  Id: string;
begin
  if not FileExists(FileName) then
    exit;
  Lines := TFile.ReadAllLines(FileName);

  if length(Lines) = 0 then
    exit;

  // Remove this line if you want full filename
  FileName := ExtractFileName(FileName);

  Id := StoreFileName(FileName);

  for Line in Lines do
    StoreLine(Line, Id);
end;

var
  Index: TIndex;
  FileNames: TArray<TFileName> = ['file1.txt', 'file2.txt', 'file3.txt'];
  FileName: TFileName;
  Querys: TArray<string> = ['Cat', 'is', 'banana', 'it', 'what'];
  Query, Found: string;

begin
  Index := TIndex.Create;

  for FileName in FileNames do
    Index.AddFile(FileName);

  for Query in Querys do
    Writeln(format('"%s" %s'#10, [Query, Index[Query]]));

  repeat
    Writeln('Enter a word to search for: (q to quit)');
    Readln(Query);

    if Query = 'q' then
      Break;

    Writeln(format('"%s" %s'#10, [Query, Index[Query]]));
  until False;

  Index.Free;
end.
