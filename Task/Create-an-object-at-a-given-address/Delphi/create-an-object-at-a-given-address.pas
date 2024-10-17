program Create_an_object_at_a_given_address;

{$APPTYPE CONSOLE}

var
  origem: Integer;
  copy: Integer absolute origem;   // This is old the trick

begin
  writeln('The "origem" adress is: ', cardinal(@origem));
  writeln('The "copy" adress is: ', cardinal(@copy));
  writeln;

  origem := 10;
  writeln('Assign 10 to "origem" ');
  writeln('The value of "origem" é ', origem);
  writeln('The value of "copy" é ', copy);
  writeln;

  copy := 2;
  writeln('Assign 2 to "copy" ');

  writeln('The value of "origem" é ', origem);
  writeln('The value of "copy" é ', copy);

  Readln;

end.
