var
  alpha := ('a'..'z') + ('A'..'Z');

procedure reverseWord(var ch: char);
begin
  var nextch := readChar();
  if nextch in alpha then reverseWord(nextch);
  write(ch);
  ch := nextch;
end;

procedure normalWord(var ch: char);
begin
  write(ch);
  ch := readChar();
  if ch in alpha then normalWord(ch);
end;

begin
  var ch := readChar();

  while ch <> '.' do
  begin
    normalWord(ch);
    if ch <> '.' then
    begin
      write(ch);
      ch := readChar();
      reverseWord(ch);
    end;
  end;
  write(ch)
end.
