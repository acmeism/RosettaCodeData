// unfold infinite sequences. Nigel Galloway: September 8th., 2022
function unfold<gN,gG>(n:Func<gG,(gN,gG)>; g:gG): sequence of gN;
begin
  var (x,r):=n(g);
  yield x;
  yield sequence unfold(n,r);
end;
function unfold<gN,gG>(n:Func<array of gG,(gN,array of gG)>;params g:array of gG): sequence of gN := unfold(n,g);
