const
  order = 4;

begin
  var size := 1 shl order - 1;
  for var y := size downto 0 do
  begin
    write(' ' * y);
    for var x := 0 to size - y do
      if (x and y) <> 0 then write('  ')
      else write('* ');
    writeln
  end;
end.
