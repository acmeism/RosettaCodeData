program Abelian_sandpile_model;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vcl.Graphics,
  System.Classes;

type
  TGrid = array of array of Integer;

function Iterate(var Grid: TGrid): Boolean;
var
  changed: Boolean;
  i: Integer;
  j: Integer;
  val: Integer;
  Alength: Integer;
begin
  Alength := length(Grid);
  changed := False;

  for i := 0 to High(Grid) do
    for j := 0 to High(Grid[0]) do
    begin
      val := Grid[i, j];
      if val > 3 then
      begin
        Grid[i, j] := Grid[i, j] - 4;

        if i > 0 then
          Grid[i - 1, j] := Grid[i - 1, j] + 1;

        if i < Alength - 1 then
          Grid[i + 1, j] := Grid[i + 1, j] + 1;

        if j > 0 then
          Grid[i, j - 1] := Grid[i, j - 1] + 1;

        if j < Alength - 1 then
          Grid[i, j + 1] := Grid[i, j + 1] + 1;
        changed := True;
      end;
    end;
  Result := changed;
end;

procedure Simulate(var Grid: TGrid);
var
  changed: Boolean;
begin
  while Iterate(Grid) do
    ;
end;

procedure Zeros(var Grid: TGrid; Size: Integer);
var
  i, j: Integer;
begin
  SetLength(Grid, Size, Size);
  for i := 0 to Size - 1 do
    for j := 0 to Size - 1 do
      Grid[i, j] := 0;
end;

procedure Println(Grid: TGrid);
var
  i, j: Integer;
begin
  for i := 0 to High(Grid) do
  begin
    Writeln;
    for j := 0 to High(Grid[0]) do
      Write(Format('%3d', [Grid[i, j]]));
  end;
  Writeln;
end;

function Grid2Bmp(Grid: TGrid): TBitmap;
const
  Colors: array[0..2] of TColor = (clRed, clLime, clBlue);
var
  Alength: Integer;
  i: Integer;
  j: Integer;
begin
  Alength := Length(Grid);

  Result := TBitmap.Create;
  Result.SetSize(Alength, Alength);

  for i := 0 to Alength - 1 do
    for j := 0 to Alength - 1 do
    begin
      Result.Canvas.Pixels[i, j] := Colors[Grid[i, j]];
    end;
end;

procedure Grid2P6(Grid: TGrid; FileName: TFileName);
var
  f: text;
  i, j, Alength: Integer;
  ppm: TFileStream;
  Header: AnsiString;
const
  COLORS: array[0..3] of array[0..2] of byte =
 //  R,   G,    B
((0   ,   0,    0),
 (255 ,   0,    0),
 (0   , 255,   0),
 (0   ,   0, 255));
begin
  Alength := Length(Grid);
  ppm := TFileStream.Create(FileName, fmCreate);
  Header := Format('P6'#10'%d %d'#10'255'#10, [Alength, Alength]);
  writeln(Header);
  ppm.Write(Tbytes(Header), Length(Header));

  for i := 0 to Alength - 1 do
    for j := 0 to Alength - 1 do
    begin
      ppm.Write(COLORS[Grid[i, j]], 3);
    end;
  ppm.Free;
end;

const
  DIMENSION = 10;

var
  Grid: TGrid;
  bmp: TBitmap;

begin
  Zeros(Grid, DIMENSION);
  Grid[4, 4] := 64;
  Writeln('Before:');
  Println(Grid);

  Simulate(Grid);

  Writeln(#10'After:');
  Println(Grid);

  // Output bmp
  with Grid2Bmp(Grid) do
  begin
    SaveToFile('output.bmp');
    free;
  end;

  // Output ppm
  Grid2P6(Grid, 'output.ppm');

  Readln;
end.
