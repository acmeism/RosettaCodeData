// Integer sequence. Nigel Galloway: September 8th., 2022
function initInfinite(start: integer):=unfold(n->(n,n+1),start);
function initInfinite(start: biginteger):=unfold(n->(n,n+1),start);
begin
  initInfinite(23).Take(10).Println;
  initInfinite(-3).Take(10).Println;
  initInfinite(2bi**70).Take(10).Println;
end.
