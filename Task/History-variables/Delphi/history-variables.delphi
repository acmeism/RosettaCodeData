program History_variables;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  THistoryVarType = record
    value: variant;
    timestamp: TDateTime;
    function ToString: string;
  end;

  THistoryVar = record
    Fvalue: variant;
    FHistory: TArray<THistoryVarType>;
  private
    procedure SetValue(const Value: Variant);
    function GetTimestamp: TDateTime;
  public
    property History: TArray<THistoryVarType> read FHistory;
    constructor Init(val: variant);
    function Dump: string;
    function Recall(steps: Integer): variant; overload;
    function Recall(timestamp: TDateTime): variant; overload;
    property Timestamp: TDateTime read GetTimestamp;
    property Value: Variant read Fvalue write SetValue;
  end;

{ THistoryVar }

function THistoryVar.Dump: string;
begin
  Result := '';
  for var h in FHistory do
    Result := Result + h.ToString + #10;
end;

function THistoryVar.GetTimestamp: TDateTime;
begin
  if Length(FHistory) = 0 then
    exit(0);
  Result := FHistory[high(FHistory)].timestamp;
end;

constructor THistoryVar.Init(val: variant);
begin
  SetLength(Fhistory, 0);
  SetValue(val);
end;

function THistoryVar.Recall(timestamp: TDateTime): variant;
begin
  for var h in FHistory do
  begin
    if h.timestamp = timestamp then
      exit(h.value);
  end;
  result := Fvalue;
end;

function THistoryVar.Recall(steps: Integer): variant;
begin
  if (steps <= 1) or (steps >= Length(FHistory)) then
    exit(value);

  result := FHistory[Length(FHistory) - steps - 1].value;
end;

procedure THistoryVar.SetValue(const Value: Variant);
begin
  SetLength(FHistory, Length(FHistory) + 1);
  FHistory[High(FHistory)].Value := Value;
  FHistory[High(FHistory)].timestamp := now;
  Fvalue := Value;
end;

{ THistoryVarType }

function THistoryVarType.ToString: string;
var
  dt: string;
begin
  DateTimeToString(dt, 'mm/dd/yyyy hh:nn:ss.zzz', timestamp);
  Result := format('%s -  %s', [dt, Value]);
end;

begin
  var v := THistoryVar.Init(0);
  v.Value := True;

  Sleep(200);
  if v.Value then
    v.Value := 'OK';

  Sleep(100);
  if v.Value = 'OK' then
    v.Value := PI;

  writeln('History of variable values:'#10);
  Writeln(v.Dump);

  Writeln('Recall 2 steps');
  Writeln(v.Recall(2));

  var t := v.History[3].timestamp;
  Writeln(#10'Recall to timestamp ', datetimetostr(t));
  Writeln(v.Recall(t));

  readln;
end.
