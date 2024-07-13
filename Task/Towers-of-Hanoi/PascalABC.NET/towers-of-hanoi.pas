## procedure Hanoi(n,rfrom,rto,rwork: integer);
begin
  if n = 0 then
    exit;
  Hanoi(n-1,rfrom,rwork,rto);
  Print($'{rfrom}→{rto} ');
  Hanoi(n-1,rwork,rto,rfrom);
end;
Hanoi(5,1,3,2);
