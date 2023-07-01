program Draw_a_cuboid;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure cubLine(n, dx, dy: Integer; cde: string);
var
  i: integer;
begin
  write(format('%' + (n + 1).ToString + 's', [cde.Substring(0, 1)]));

  for i := 9 * dx - 1 downto 1 do
    Write(cde.Substring(1, 1));

  Write(cde.Substring(0, 1));
  Writeln(cde.Substring(2, cde.Length).PadLeft(dy + 1));
end;

procedure cuboid(dx, dy, dz: integer);
var
  i: integer;
begin
  Writeln(Format('cuboid %d %d %d:', [dx, dy, dz]));

  cubLine(dy + 1, dx, 0, '+-');

  for i := 1 to dy do
    cubLine(dy - i + 1, dx, i - 1, '/ |');

  cubLine(0, dx, dy, '+-|');

  for i := 4 * dz - dy - 2 downto 1 do
    cubLine(0, dx, dy, '| |');

  cubLine(0, dx, dy, '| +');

  for i := 1 to dy do
    cubLine(0, dx, dy - i, '| /');

  cubLine(0, dx, 0, '+-');
  Writeln;
end;

begin
  cuboid(2, 3, 4);
  cuboid(1, 1, 1);
  cuboid(6, 2, 1);

  readln;
end.
