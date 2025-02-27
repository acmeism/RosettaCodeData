##
function Leonardo(L0: integer; L1: integer; add: integer): sequence of integer;
begin
  while (true) do
  begin
    yield L0;
    (L0, L1) := (L1, L0 + L1 + add);
  end;
end;

Leonardo(1, 1, 1).Take(25).println;
Leonardo(0, 1, 0).Take(25).println;
