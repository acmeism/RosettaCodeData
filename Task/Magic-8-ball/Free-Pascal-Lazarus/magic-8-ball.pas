program Magic_8_ball;
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  SysUtils,crt;
const
  answers: array[0..19] of string = ('It is certain.', 'It is decidedly so.',
    'Without a doubt.', 'Yes - definitely.', 'You may rely on it.',
    'As I see it, yes.', 'Most likely.', 'Outlook good.', 'Yes.',
    'Signs point to yes.', 'Reply hazy, try again.', 'Ask again later',
    'Better not tell you now.', 'Cannot predict now.',
    'Concentrate and ask again.', 'Don''t count on it.', 'My reply is no.',
    'My sources say no.', 'Outlook not so good.', 'Very doubtful.');
begin
  Randomize;
  repeat
    writeln('Magic 8 Ball! Ask question and hit ENTER key for the answer!');
    readln;
    ClrScr;
    writeln(answers[Random(length(answers))],#13#10);
    writeln('Hit ESCape to leave');
    repeat until keypressed;
    ClrScr;
  until readkey=#27;
end.
