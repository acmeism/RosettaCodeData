function SentenceType(s: string): char;
begin
  case s[^1] of
    '?': Result := 'Q';
    '!': Result := 'E';
    '.': Result := 'S';
    else Result := 'N';
  end;
end;

begin
  var ss := Arr('hi there, how are you today?',
    'I''d like to present to you the washing machine 9001.',
    'You have been nominated to win one of these!',
    'Just make sure you don''t break it');
  foreach var s in ss do
    Println(s,'->',SentenceType(s));
end.
