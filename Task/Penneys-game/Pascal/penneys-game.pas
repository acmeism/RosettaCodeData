PROGRAM Penney;

TYPE
    CoinToss = (heads, tails);
    Sequence = array [1..3] of CoinToss;
    Player = record
        bet: Sequence;
        score: integer;
    end;

VAR
    Human, Computer: Player;
    Rounds, Count: integer;

Function TossCoin: CoinToss;
{ Returns heads or tails at random }
Begin
    if random(2) = 1 then TossCoin := Heads
    else TossCoin := tails
End;

Procedure PutToss(toss: CoinToss);
{ Outputs heads or tails as a letter }
Begin
    if toss = heads then write('H')
    else write('T')
End;

Function GetToss: CoinToss;
{ Reads H or T from the keyboard in either lettercase }
var c: char;
Begin
    { Keep reading characters until we get an appropriate letter }
    repeat read(c) until c in ['H', 'h', 'T', 't'];
    { Interpret the letter }
    if c in ['H', 'h'] then GetToss := heads
    else GetToss := tails
End;

Procedure ShowSequence(tosses: Sequence);
{ Outputs three coin tosses at once }
Var
    i: integer;
Begin
    for i := 1 to 3 do PutToss(tosses[i])
End;

Procedure ReadSequence(var tosses: Sequence);
{ Accepts three coin tosses from the keyboard }
Var i: integer;
Begin
    { Get the 3 letters }
    for i := 1 to 3 do tosses[i] := GetToss;
    { Ignore the rest of the line }
    readln
End;

Function Optimum(opponent: Sequence): Sequence;
{ Generates the optimum sequence against an opponent }
Begin
    case opponent[2] of
        heads: Optimum[1] := tails;
        tails: Optimum[1] := heads
    end;
    Optimum[2] := opponent[1];
    Optimum[3] := opponent[2]
End;

Function RandomSequence: Sequence;
{ Generates three random coin tosses }
Var
    i: integer;
Begin
    for i := 1 to 3 do RandomSequence[i] := TossCoin
End;

Function Match(first, second: Sequence): Boolean;
{ Detects whether a sequence of tosses matches another }
Var
    different: boolean;
    i: integer;
Begin
    different := false;
    i := 1;
    while (i <= 3) and not different do begin
        if not (first[i] = second[i]) then different := true;
        i := i + 1
    end;
    Match := not different
End;

Procedure PlayRound(var human, computer: Player);
{ Shows coin tosses and announces the winner }
Var
    { We only ever need to store the 3 most recent tosses in memory. }
    tosses: Sequence;
Begin
    { Start with the first three tosses }
    write('Tossing the coin: ');
    tosses := RandomSequence;
    ShowSequence(tosses);
    { Keep tossing the coin until there is a winner. }
    while not (Match(human.bet, tosses) or Match(computer.bet, tosses)) do begin
        tosses[1] := tosses[2];
        tosses[2] := tosses[3];
        tosses[3] := TossCoin;
        PutToss(tosses[3])
    end;
    { Update the winner's score and announce the winner }
    writeln;
    writeln;
    if Match(human.bet, tosses) then begin
        writeln('Congratulations! You won this round.');
        human.score := human.score + 1;
        writeln('Your new score is ', human.score, '.')
    end
    else begin
        writeln('Yay, I won this round!');
        computer.score := computer.score + 1;
        writeln('My new score is ', computer.score, '.')
    end
End;

{ Main Algorithm }

BEGIN

    { Welcome the player }
    writeln('Welcome to Penney''s game!');
    writeln;
    write('How many rounds would you like to play? ');
    readln(Rounds);
    writeln;
    writeln('Ok, let''s play ', Rounds, ' rounds.');

    { Start the game }
    randomize;
    Human.score := 0;
    Computer.score := 0;

    for Count := 1 to Rounds do begin

        writeln;
        writeln('*** Round #', Count, ' ***');
        writeln;

        { Choose someone randomly to pick the first sequence }
        if TossCoin = heads then begin
            write('I''ll pick first this time.');
            Computer.bet := RandomSequence;
            write(' My sequence is ');
            ShowSequence(Computer.bet);
            writeln('.');
            repeat
                write('What sequence do you want? ');
                ReadSequence(Human.bet);
                if Match(Human.bet, Computer.bet) then
                    writeln('Hey, that''s my sequence! Think for yourself!')
            until not Match(Human.bet, Computer.bet);
            ShowSequence(Human.bet);
            writeln(', huh? Sounds ok to me.')
        end
        else begin
            write('You pick first this time. Enter 3 letters H or T: ');
            ReadSequence(Human.bet);
            Computer.bet := Optimum(Human.bet);
            write('Ok, so you picked ');
            ShowSequence(Human.bet);
            writeln;
            write('My sequence will be ');
            ShowSequence(Computer.bet);
            writeln
        end;

        { Then we can actually play the round }
        writeln('Let''s go!');
        writeln;
        PlayRound(Human, Computer);
        writeln;
        writeln('Press ENTER to go on...');
        readln

    end;

    { All the rounds are finished; time to decide who won }
    writeln;
    writeln('*** End Result ***');
    writeln;
    if Human.score > Computer.score then writeln('Congratulations! You won!')
    else if Computer.score > Human.score then writeln('Hooray! I won')
    else writeln('Cool, we tied.');
    writeln;
    writeln('Press ENTER to finish.');
    readln

END.
