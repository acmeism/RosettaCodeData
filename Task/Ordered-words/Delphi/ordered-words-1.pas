program POrderedWords;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, IdHTTP;

function IsOrdered(const s:string): Boolean;
var
  I: Integer;
begin
  Result := Length(s)<2; // empty or 1 char strings are ordered
  for I := 2 to Length(s) do
    if s[I]<s[I-1] then // can improve using case/localization to order...
      Exit;
  Result := True;
end;

function ProcessDictionary(const AUrl: string): string;
var
  slInput: TStringList;
  I, WordSize: Integer;
begin
  slInput := TStringList.Create;
  try
    with TIdHTTP.Create(nil) do try
      slInput.Text := Get(AUrl);
    finally
      Free;
    end;
    // or use slInput.LoadFromFile('yourfilename') to load from a local file
    WordSize :=0;
    for I := 0 to slInput.Count-1 do begin
      if IsOrdered(slInput[I]) then
        if (Length(slInput[I]) = WordSize) then
          Result := Result + slInput[I] + ' '
        else if (Length(slInput[I]) > WordSize) then begin
          Result := slInput[I] + ' ';
          WordSize := Length(slInput[I]);
        end;
    end;
  finally
    slInput.Free;
  end;
end;

begin
  try
    WriteLn(ProcessDictionary('http://www.puzzlers.org/pub/wordlists/unixdict.txt'));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
