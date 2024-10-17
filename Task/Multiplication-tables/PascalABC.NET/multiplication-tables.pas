##
write('  x|');
for var i := 1 to 12 do write(i:4);
writeln(#13, '---+', '-' * 48);
for var i := 1 to 12 do
begin
  write(i:3, '|', ' ' * (4 * i - 4));
  for var j := i to 12 do write(i * j:4);
  writeln;
end;
