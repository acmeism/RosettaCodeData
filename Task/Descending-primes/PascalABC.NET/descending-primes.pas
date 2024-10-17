##
uses School;

function DescendingSeq(n: integer): sequence of integer;
begin
  if n = 0 then
    for var x := 9 downto 1 do
      yield sequence DescendingSeq(x) + x
  else for var x := n*10 + n mod 10 - 1 downto n*10  + 1 do
    yield sequence DescendingSeq(x) + x;
end;

DescendingSeq(0).Order.Where(n -> n.IsPrime).Print;
