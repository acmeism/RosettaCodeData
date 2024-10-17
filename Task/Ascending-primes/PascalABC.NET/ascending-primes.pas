##
uses School;

function AscendingSeq(n: integer): sequence of integer;
begin
  for var x := n*10 + n mod 10 + 1 to n*10 + 9 do
    yield sequence AscendingSeq(x) + x;
end;

AscendingSeq(0).Order.Where(n -> n.IsPrime).Print;
