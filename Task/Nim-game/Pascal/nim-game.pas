program Nim;

{$mode objfpc}{$H+}

uses
  sysutils;

const
   maxtokens = 12;
   machine = 0;
   human = 1;

var
  player, tokens, taken : integer;

procedure Welcome;
begin
  writeln('The Game of Nim');
  writeln;
  writeln('This is one of many variants of the classic game of');
  writeln('Nim. We start with',maxtokens,' tokens. On each turn a player');
  writeln('takes between 1 and 3 tokens. The player who takes');
  writeln('the last token wins.');
  writeln;
end;

procedure ShowRemaining(n : integer);
begin
  writeln('Available tokens: ', n);
end;

function getnum(lowlim, toplim : integer) : integer ;
var
  n : integer;
  ok : boolean;
begin
  repeat
    write('You take: ');
    readln(n);
    if (n < lowlim) or (n > toplim) then
      begin
        writeln('Must take between ',lowlim,' and ',toplim);
        write('Try again: ');
        ok := false;
      end
    else
      ok := true;
  until ok;
  getnum := n;
end;

function PlayTurn(player, taken, tokens : integer) : integer;
begin
  if player = human then
      taken := getnum(1,3)
  else   { machine's move this time }
     begin
       if tokens <= 3 then
         taken := tokens     { take all if 3 or less remain }
       else
         taken := 4 - taken; { othewise, follow winning strategy }
     end;
  PlayTurn := taken;
end;

procedure Report(winner : integer);
begin
  if winner = human then
    writeln('You took the last one, so you win. Congratulations!')
  else
    writeln('I took the last one, so I win. Sorry about that.');
end;

begin
  Welcome;
  tokens := maxtokens;
  taken := 0;
  player := human;
  writeln('You go first');
  repeat
    ShowRemaining(tokens);
    taken := PlayTurn(player, taken, tokens);
    if player = machine then writeln('I took: ',taken);
    tokens := tokens - taken;
    if tokens > 0 then player := 1 - player;
  until tokens <= 0;
  report(player);
  writeln('Thanks for playing!');
  readln;
end.
