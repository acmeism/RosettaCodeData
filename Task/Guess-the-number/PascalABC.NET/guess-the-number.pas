begin
  var randomNumber := Random(1..10);
  Println('I''m thinking of a number between 1 and 10. Can you guess it?');
  while True do
  begin
    Print('Guess:');
    var x := ReadlnInteger;
    if x = randomNumber then
      break;
    Println('That''s not it. Guess again.');
  end;
  Println('Congrats!! You guessed right!6');
end.
