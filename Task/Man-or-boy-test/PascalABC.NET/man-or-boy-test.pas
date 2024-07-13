function A(k: integer; x1, x2, x3, x4, x5: function: integer): integer;
begin
  var B: function: integer;
  B := () -> begin
    k := k - 1;
    Result := A(k, B, x1, x2, x3, x4);
  end;
  Result := if k <= 0 then x4() + x5() else B()
end;

begin
  Print(A(10, () -> 1, () -> -1, () -> -1, () -> 1, () -> 0))
end.
