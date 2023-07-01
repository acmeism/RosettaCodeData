program Cartesian_product_of_two_or_more_lists;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TList = TArray<Integer>;

  TLists = TArray<TList>;

  TListHelper = record helper for TList
    function ToString: string;
  end;

  TListsHelper = record helper for TLists
    function ToString(BreakLines: boolean = false): string;
  end;

function cartN(arg: TLists): TLists;
var
  b, n: TList;
  argc: Integer;
begin
  argc := length(arg);

  var c := 1;
  for var a in arg do
    c := c * length(a);

  if c = 0 then
    exit;

  SetLength(result, c);
  SetLength(b, c * argc);
  SetLength(n, argc);

  var s := 0;
  for var i := 0 to c - 1 do
  begin
    var e := s + argc;
    var Resi := copy(b, s, e - s);
    Result[i] := Resi;

    s := e;
    for var j := 0 to high(n) do
    begin
      var nj := n[j];
      Resi[j] := arg[j, nj];
    end;

    for var j := high(n) downto 0 do
    begin
      inc(n[j]);
      if n[j] < Length(arg[j]) then
        Break;
      n[j] := 0;
    end;
  end;
end;

{ TListHelper }

function TListHelper.ToString: string;
begin
  Result := '[';
  for var i := 0 to High(self) do
  begin
    Result := Result + self[i].ToString;
    if i < High(self) then
      Result := Result + ' ';
  end;
  Result := Result + ']';
end;

{ TListsHelper }

function TListsHelper.ToString(BreakLines: boolean = false): string;
begin
  Result := '[';
  for var i := 0 to High(self) do
  begin
    Result := Result + self[i].ToString;
    if i < High(self) then
    begin
      if BreakLines then
        Result := Result + #10
      else
        Result := Result + ' ';
    end;
  end;
  Result := Result + ']';
end;

begin
  writeln(#10, cartN([[1, 2], [3, 4]]).ToString);
  writeln(#10, cartN([[3, 4], [1, 2]]).ToString);
  writeln(#10, cartN([[1, 2], []]).ToString);
  writeln(#10, cartN([[], [1, 2]]).ToString);

  writeln(#10, cartN([[1776, 1789], [17, 12], [4, 14, 23], [0, 1]]).ToString(True));

  writeln(#10, cartN([[1, 2, 3], [30], [500, 100]]).ToString);

  writeln(#10, cartN([[1, 2, 3], [], [500, 100]]).ToString);

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
