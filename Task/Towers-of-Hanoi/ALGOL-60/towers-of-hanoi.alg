begin
  procedure movedisk(n, f, t);
  integer n, f, t;
  begin
    outstring (1, "Move disk from");
    outinteger(1, f);
    outstring (1, "to");
    outinteger(1, t);
    outstring (1, "\n");
  end;

  procedure dohanoi(n, f, t, u);
  integer n, f, t, u;
  begin
    if n < 2 then
      movedisk(1, f, t)
    else
      begin
        dohanoi(n - 1, f, u, t);
        movedisk(1, f, t);
        dohanoi(n - 1, u, t, f);
      end;
  end;

  dohanoi(4, 1, 2, 3);
  outstring(1,"Towers of Hanoi puzzle completed!")
end
