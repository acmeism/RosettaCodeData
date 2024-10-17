program Cut_a_rectangle;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  grid: array of byte;
  w, h, len: Integer;
  cnt: UInt64;
  next: array of Integer;
  dir: array of array of Integer = [[0, -1], [-1, 0], [0, 1], [1, 0]];

procedure walk(y, x: Integer);
var
  i, t: Integer;
begin
  if (y = 0) or (y = h) or (x = 0) or (x = w) then
  begin
    inc(cnt);
    Exit;
  end;
  t := y * (w + 1) + x;
  inc(grid[t]);
  inc(grid[len - t]);

  for i := 0 to 3 do
    if grid[t + next[i]] = 0 then
      walk(y + dir[i][0], x + dir[i][1]);
  dec(grid[t]);
  dec(grid[len - t]);
end;

function solve(hh, ww: Integer; recur: Boolean): UInt64;
var
  t, cx, cy, x, i: Integer;
begin
  h := hh;
  w := ww;

  if Odd(h) then
  begin
    t := w;
    w := h;
    h := t;
  end;

  if Odd(h) then
    Exit(0);

  if w = 1 then
    Exit(1);

  if w = 2 then
    Exit(h);

  if h = 2 then
    Exit(w);

  cy := h div 2;
  cx := w div 2;
  len := (h + 1) * (w + 1);

  setlength(grid, len);

  for i := 0 to High(grid) do
    grid[i] := 0;

  dec(len);

  next := [-1, -w - 1, 1, w + 1];

  if recur then
    cnt := 0;

  for x := cx + 1 to w - 1 do
  begin
    t := cy * (w + 1) + x;
    grid[t] := 1;
    grid[len - t] := 1;
    walk(cy - 1, x);
  end;
  Inc(cnt);

  if h = w then
    inc(cnt, 2)
  else if not odd(w) and recur then
    solve(w, h, False);
  Result := cnt;
end;

var
  y, x: Integer;

begin
  for y := 1 to 10 do
    for x := 1 to y do
      if not Odd(x) or not Odd(y) then
        writeln(format('%d x %d:  %d', [y, x, solve(y, x, True)]));
  Readln;
end.
