program Compare_a_list_of_strings;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  // generic alias for use helper. The "TArray<string>" will be work too
  TListString = TArray<string>;

  TListStringHelper = record helper for TListString
    function AllEqual: boolean;
    function AllLessThan: boolean;
    function ToString: string;
  end;

{ TListStringHelper }

function TListStringHelper.AllEqual: boolean;
begin
  Result := True;
  if Length(self) < 2 then
    exit;

  var first := self[0];
  for var i := 1 to High(self) do
    if self[i] <> first then
      exit(False);
end;

function TListStringHelper.AllLessThan: boolean;
begin
  Result := True;
  if Length(self) < 2 then
    exit;

  var last := self[0];
  for var i := 1 to High(self) do
  begin
    if not (last < self[i]) then
      exit(False);
    last := self[i];
  end;
end;

function TListStringHelper.ToString: string;
begin
  Result := '[';
  Result := Result + string.join(', ', self);
  Result := Result + ']';
end;

var
  lists: TArray<TArray<string>>;

begin
  lists := [['a'], ['a', 'a'], ['a', 'b']];

  for var list in lists do
  begin
    writeln(list.ToString);
    writeln('Is AllEqual: ', list.AllEqual);
    writeln('Is AllLessThan: ', list.AllLessThan, #10);
  end;

  readln;
end.
