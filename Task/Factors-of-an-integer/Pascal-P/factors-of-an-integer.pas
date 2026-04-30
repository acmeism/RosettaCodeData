program factint(output);

  (* Factors of an integer *)

  procedure writefactors(n: integer);
  var
    i: integer;
  begin
    write(n, ' => ');
    n := abs(n);
    for i := 1 to n div 2 do
      if n mod i = 0 then
        write(i: 1, ' ');
    writeln(n: 1);
  end;

begin
  writefactors(11);
  writefactors(21);
  writefactors(32);
  writefactors(45);
  writefactors(67);
  writefactors(96);
  (* readln; *)
end.
