program Tic(Input, Output);

type
  Contents = (Unassigned, Human, Computer);
var
  BestI, BestJ: integer; { best solution a depth of zero in the search }
  B: array[0..2, 0..2] of Contents;  {zero based so modulus works later}
  Player: Contents;

  procedure DisplayBoard;
  var
    I, J: integer;
    T: array [Contents] of char;
  begin
    T[Unassigned] := ' ';
    T[Human] := 'O';
    T[Computer] := 'X';
    for I := 0 to 2 do
    begin
      for J := 0 to 2 do
      begin
        Write(T[B[I, J]]);
        if J <> 2 then
          Write(' | ');
      end;
      WriteLn;
      if I < 2 then
        WriteLn('---------');
    end;
    WriteLn;
    WriteLn;
  end;

  function SwapPlayer(Player: Contents): Contents;
  begin
    if Player = Computer then
      SwapPlayer := Human
    else
      SwapPlayer := Computer;
  end;

  function CheckWinner: Contents;
  var
    I: integer;
  begin
    CheckWinner := Unassigned; { no winner yet }
    for I := 0 to 2 do
    begin
      { first horizontal solution }
      if (CheckWinner = Unassigned) and (B[I, 0] <> Unassigned) and
        (B[I, 1] = B[I, 0]) and (B[I, 2] = B[I, 0]) then
        CheckWinner := B[I, 0]
      else
      { now vertical solution }
      if (CheckWinner = Unassigned) and (B[0, I] <> Unassigned) and
        (B[1, I] = B[0, I]) and (B[2, I] = B[0, I]) then
        CheckWinner := B[0, I];
    end;
    { now check the paths of the two cross line slants that share the middle position }
    if (CheckWinner = Unassigned) and (B[1, 1] <> Unassigned) then
    begin
      if (B[1, 1] = B[0, 0]) and (B[2, 2] = B[0, 0]) then
        CheckWinner := B[0, 0]
      else if (B[1, 1] = B[2, 0]) and (B[0, 2] = B[1, 1]) then
        CheckWinner := B[1, 1];
    end;
  end;

  { Basic strategy test - is this te best solution we have seen }
  function SaveBest(CurScore, CurBest: Contents): boolean;
  begin
    if CurScore = CurBest then
      SaveBest := False
    else if (CurScore = Unassigned) and (CurBest = Human) then
      SaveBest := False
    else if (CurScore = Computer) and ((CurBest = Unassigned) or
      (CurBest = Human)) then
      SaveBest := False
    else
      SaveBest := True;
  end;


  { Basic strategy - recursive depth first search of possible moves
  if computer can win save it, otherwise block if need be, else do deeper.
  At each level modify the board for the next call, but clean up as go back up,
  by remembering the modified position on the call stack. }
  function TestMove(Val: Contents; Depth: integer): Contents;
  var
    I, J: integer;
    Score, Best, Changed: Contents;
  begin
    Best := Computer;
    Changed := Unassigned;
    Score := CheckWinner;
    if Score <> Unassigned then
    begin
      if Score = Val then
        TestMove := Human
      else
        TestMove := Computer;
    end
    else
    begin
      for I := 0 to 2 do
        for J := 0 to 2 do
        begin
          if B[I, J] = Unassigned then
          begin
            Changed := Val;
            B[I, J] := Val;
            { the value for now and try wioth the other player }
            Score := TestMove(SwapPlayer(Val), Depth + 1);
            if Score <> Unassigned then
              Score := SwapPlayer(Score);
            B[I, J] := Unassigned;
            if SaveBest(Score, Best) then
            begin
              if Depth = 0 then
              begin { top level, so remember actual position }
                BestI := I;
                BestJ := J;
              end;
              Best := Score;
            end;
          end;
        end;
      if Changed <> Unassigned then
        TestMove := Best
      else
        TestMove := Unassigned;
    end;
  end;

  function PlayGame(Whom: Contents): string;
  var
    I, J, K, Move: integer;
    Win: Contents;
  begin
    Win := Unassigned;
    for I := 0 to 2 do
      for J := 0 to 2 do
        B[I, J] := Unassigned;
    WriteLn('The board positions are numbered as follows:');
    WriteLn('1 | 2 | 3');
    WriteLn('---------');
    WriteLn('4 | 5 | 6');
    WriteLn('---------');
    WriteLn('7 | 8 | 9');
    WriteLn('You have O, I have X.');
    WriteLn;
    K := 1;
    repeat {rather a for loop but can not have two actions or early termination in Pascal}
      if Whom = Human then
      begin
        repeat
          Write('Your move: ');
          ReadLn(Move);
          if (Move < 1) or (Move > 9) then
            WriteLn('Opps: enter a number between 1 - 9.');
          Dec(Move);
          {humans do 1 -9, but the computer wants 0-8 for modulus to work}
          I := Move div 3; { convert from range to corridinated of the array }
          J := Move mod 3;
          if B[I, J] <> Unassigned then
            WriteLn('Opps: move ', Move + 1, ' was already done.')
        until (Move >= 0) and (Move <= 8) and (B[I, J] = Unassigned);
        B[I, J] := Human;
      end;
      if Whom = Computer then
      begin
        { randomize if computer opens, so its not always the same game }
        if K = 1 then
        begin
          BestI := Random(3);
          BestJ := Random(3);
        end
        else
          Win := TestMove(Computer, 0);
        B[BestI, BestJ] := Computer;
        WriteLn('My move: ', BestI * 3 + BestJ + 1);
      end;
      DisplayBoard;
      Win := CheckWinner;
      if Win <> Unassigned then
      begin
        if Win = Human then
          PlayGame := 'You win.'
        else
          PlayGame := 'I win.';
      end
      else
      begin
        Inc(K); { "for" loop counter actions }
        Whom := SwapPlayer(Whom);
      end;
    until (Win <> Unassigned) or (K > 9);
    if Win = Unassigned then
      PlayGame := 'A draw.';
  end;

begin
  Randomize;
  Player := Human;
  while True do
  begin
    WriteLn(PlayGame(Player));
    WriteLn;
    Player := SwapPlayer(Player);
  end
end.
