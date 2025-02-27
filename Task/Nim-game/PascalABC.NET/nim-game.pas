##
writeln('There are twelve tokens.');
writeln('You can take 1, 2, or 3 on your turn.');
writeln('Whoever takes the last token wins.');

var tokens := 12;

while (tokens > 0) do
begin
  writeln('There are ' + tokens + ' remaining.');
  writeln('How many do you take?');
  var playertake := ReadInteger;

  if (playertake < 1) or (playertake > 3) then
    writeln('1, 2 or 3 only.')
  else
          begin
    tokens -= playertake;
    writeln('I take ' + (4 - playertake) + '.');
    tokens -= (4 - playertake);
  end;
end;

writeln('I win again.');
