unit uSettings;

interface

uses
  System.SysUtils, System.IoUtils, System.Generics.Collections, System.Variants;

type
  TVariable = record
    value: variant;
    function ToString: string;
    class operator Implicit(a: variant): TVariable;
    class operator Implicit(a: TVariable): TArray<string>;
    class operator Implicit(a: TVariable): string;
  end;

  TSettings = class(TDictionary<string, TVariable>)
  private
    function GetVariable(key: string): TVariable;
    procedure SetVariable(key: string; const Value: TVariable);
    function GetKey(line: string; var key: string; var value: variant; var
      disable: boolean): boolean;
    function GetAllKeys: TList<string>;
  public
    procedure LoadFromFile(Filename: TfileName);
    procedure SaveToFile(Filename: TfileName);
    property Variable[key: string]: TVariable read GetVariable write SetVariable; default;
  end;

implementation

{ TVariable }

class operator TVariable.Implicit(a: variant): TVariable;
begin
  Result.value := a;
end;

class operator TVariable.Implicit(a: TVariable): TArray<string>;
begin
  if VarIsType(a.value, varArray or varOleStr) then
    Result := a.value
  else
    raise Exception.Create('Error: can''t convert this type data in array');
end;

class operator TVariable.Implicit(a: TVariable): string;
begin
  Result := a.ToString;
end;

function TVariable.ToString: string;
var
  arr: TArray<string>;
begin
  if VarIsType(value, varArray or varOleStr) then
  begin
    arr := value;
    Result := string.Join(', ', arr).Trim;
  end
  else
    Result := value;
  Result := Result.Trim;
end;

{ TSettings }

function TSettings.GetAllKeys: TList<string>;
var
  key: string;
begin
  Result := TList<string>.Create;
  for key in Keys do
    Result.Add(key);
end;

function TSettings.GetKey(line: string; var key: string; var value: variant; var
  disable: boolean): boolean;
var
  line_: string;
  j: integer;
begin
  line_ := line.Trim;
  Result := not (line_.IsEmpty or (line_[1] = '#'));
  if not Result then
    exit;

  disable := (line_[1] = ';');
  if disable then
    delete(line_, 1, 1);

  var data := line_.Split([' '], TStringSplitOptions.ExcludeEmpty);
  case length(data) of
    1: //Boolean
      begin
        key := data[0].ToUpper;
        value := True;
      end;

    2: //Single String
      begin
        key := data[0].ToUpper;
        value := data[1].Trim;
      end;

  else // Mult String value or Array of value
    begin
      key := data[0];
      delete(line_, 1, key.Length);
      if line_.IndexOf(',') > -1 then
      begin
        data := line_.Trim.Split([','], TStringSplitOptions.ExcludeEmpty);
        for j := 0 to High(data) do
          data[j] := data[j].Trim;
        value := data;
      end
      else
        value := line_.Trim;
    end;
  end;
  Result := true;
end;

function TSettings.GetVariable(key: string): TVariable;
begin
  key := key.Trim.ToUpper;
  if not ContainsKey(key) then
    add(key, false);

  result := Items[key];
end;

procedure TSettings.LoadFromFile(Filename: TfileName);
var
  key, line: string;
  value: variant;
  disabled: boolean;
  Lines: TArray<string>;
begin
  if not FileExists(Filename) then
    exit;

  Clear;
  Lines := TFile.ReadAllLines(Filename);
  for line in Lines do
  begin
    if GetKey(line, key, value, disabled) then
    begin
      if disabled then
        AddOrSetValue(key, False)
      else
        AddOrSetValue(key, value)
    end;
  end;
end;

procedure TSettings.SaveToFile(Filename: TfileName);
var
  key, line: string;
  value: variant;
  disabled: boolean;
  Lines: TArray<string>;
  i: Integer;
  All_kyes: TList<string>;
begin
  All_kyes := GetAllKeys();
  SetLength(Lines, 0);
  i := 0;
  if FileExists(Filename) then
  begin
    Lines := TFile.ReadAllLines(Filename);
    for i := high(Lines) downto 0 do
    begin
      if GetKey(Lines[i], key, value, disabled) then
      begin
        if not ContainsKey(key) then
        begin
          Lines[i] := '; ' + Lines[i];
          Continue;
        end;

        All_kyes.Remove(key);

        disabled := VarIsType(Variable[key].value, varBoolean) and (Variable[key].value
          = false);
        if not disabled then
        begin
          if VarIsType(Variable[key].value, varBoolean) then
            Lines[i] := key
          else
            Lines[i] := format('%s %s', [key, Variable[key].ToString])
        end
        else
          Lines[i] := '; ' + key;
      end;
    end;

  end;

  // new keys
  i := high(Lines) + 1;
  SetLength(Lines, Length(Lines) + All_kyes.Count);
  for key in All_kyes do
  begin
    Lines[i] := format('%s %s', [key, Variable[key].ToString]);
    inc(i);
  end;

  Tfile.WriteAllLines(Filename, Lines);

  All_kyes.Free;
end;

procedure TSettings.SetVariable(key: string; const Value: TVariable);
begin
  AddOrSetValue(key.Trim.ToUpper, Value);
end;
end.
