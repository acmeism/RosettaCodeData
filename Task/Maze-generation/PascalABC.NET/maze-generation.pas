const
  w = 14;
  h = 10;

var
  vis := (0..h - 1).Select(x -> [false] * w).ToArray;
  hor := (0..h).select(x -> ['+---'] * w + [string('+')]).ToArray;
  ver := (0..h - 1).select(x -> ['|   '] * w + [string('|')]).ToArray;

procedure walk(x, y: integer);
begin
  vis[y][x] := true;
  foreach var p in ||x - 1, y|, |x, y + 1|, |x + 1, y|, |x, y - 1||.Shuffle do
  begin
    if (p[0] not in (0..w - 1)) or (p[1] not in (0..h - 1)) or vis[p[1]][p[0]] then continue;
    if p[0] = x then hor[max(y, p[1])][x] := '+   ';
    if p[1] = y then ver[y][max(x, p[0])] := '    ';
    walk(p[0], p[1]);
  end;
end;

begin
  walk(random(w), random(h));
  foreach var (a, b) in hor.zip(ver + [''], (x, y) -> (x, y)) do
  begin
    a.println('');
    b.println('');
  end;
end.
