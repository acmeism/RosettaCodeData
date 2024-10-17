##
function deconv(g, f: array of real): array of real;
begin
  var h: array of real;
  setlength(h, g.length - f.length + 1);
  for var n := 0 to h.length - 1 do
  begin
    h[n] := g[n];
    var lower: integer;
    if n >= f.length then
      lower := n - f.length + 1;
    for var i := lower to n - 1 do
      h[n] -= h[i] * f[n - i];
    h[n] /= f[0];
  end;
  result := h;
end;

var h := |-8.0, -9, -3, -1, -6, 7|;
var f := |-3.0, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1|;
var g := |24.0, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
          96, 31, 55, 36, 29, -43, -7|;
h.Println;
deconv(g, f).Println;
f.Println;
deconv(g, h).Println;
