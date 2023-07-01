program Wireworld;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils;

var
  rows, cols: Integer;
  rx, cx: Integer;
  mn: TArray<Integer>;

procedure Print(grid: TArray<byte>);
begin
  writeln(string.Create('_', cols * 2), #10);

  for var r := 1 to rows do
  begin
    for var c := 1 to cols do
    begin
      if grid[r * cx + c] = 0 then
        write(' ')
      else
        write(' ', chr(grid[r * cx + c]));
    end;
    writeln;
  end;
end;

procedure Step(var dst: TArray<byte>; src: TArray<byte>);
begin
  for var r := 1 to rows do
  begin
    for var c := 1 to cols do
    begin
      var x := r * cx + c;
      dst[x] := src[x];

      case chr(dst[x]) of
        'H':
          dst[x] := ord('t');
        't':
          dst[x] := ord('.');
        '.':
          begin
            var nn := 0;
            for var n in mn do
              if src[x + n] = ord('H') then
                inc(nn);
            if (nn = 1) or (nn = 2) then
              dst[x] := ord('H');
          end;
      end;
    end;
  end;
end;

procedure Main();
const
  CONFIG_FILE = 'ww.config';
begin

  if not FileExists(CONFIG_FILE) then
  begin
    Writeln(CONFIG_FILE, ' not exist');
    exit;
  end;

  var srcRows := TFile.ReadAllLines(CONFIG_FILE);

  rows := length(srcRows);

  cols := 0;
  for var r in srcRows do
  begin
    if Length(r) > cols then
      cols := length(r);
  end;

  rx := rows + 2;
  cx := cols + 2;

  mn := [-cx - 1, -cx, -cx + 1, -1, 1, cx - 1, cx, cx + 1];

  var _odd: TArray<byte>;
  var _even: TArray<byte>;

  SetLength(_odd, rx * cx);
  SetLength(_even, rx * cx);

  FillChar(_odd[0], rx * cx, 0);
  FillChar(_even[0], rx * cx, 0);

  for var i := 0 to High(srcRows) do
  begin
    var r := srcRows[i];

    var offset := (i + 1) * cx + 1;
    for var j := 1 to length(r) do
      _odd[offset + j - 1] := ord(r[j]);
  end;

  while True do
  begin
    print(_odd);
    step(_even, _odd);
    Readln;

    print(_even);
    step(_odd, _even);
    Readln;
  end;
end;

begin
  Main;

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
