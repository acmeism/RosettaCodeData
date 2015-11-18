program Pig;

const
	WinningScore = 100;

type
	DieRoll = 1..6;
	Score = integer;
	Player = record
		Name: string;
		Points: score;
		Victory: Boolean
	end;

{ Assume a 2-player game. }
var Player1, Player2: Player;

function RollTheDie: DieRoll;
  { Return a random number 1 thru 6. }
	begin
		RollTheDie := random(6) + 1
	end;

procedure TakeTurn (var P: Player);
  { Play a round of Pig. }
	var
		Answer: char;
		Roll: DieRoll;
		NewPoints: Score;
		KeepPlaying: Boolean;
	begin
		NewPoints := 0;
		writeln ;
		writeln('It''s your turn, ', P.Name, '!');
		writeln('So far, you have ', P.Points, ' points in all.');
		writeln ;
		{ Keep playing until the user rolls a 1 or chooses not to roll. }
		write('Do you want to roll the die (y/n)? ');
		readln(Answer);
		KeepPlaying := upcase(Answer) = 'Y';
		while KeepPlaying do
		 begin
			Roll := RollTheDie;
			if Roll = 1 then
			 begin
				NewPoints := 0;
				KeepPlaying := false;
				writeln('Oh no! You rolled a 1! No new points after all.')
			 end
			else
			 begin
				NewPoints := NewPoints + Roll;
				write('You rolled a ', Roll:1, '. ');
				writeln('That makes ', NewPoints, ' new points so far.');
				writeln ;
				write('Roll again (y/n)? ');
				readln(Answer);
				KeepPlaying := upcase(Answer) = 'Y'
			 end
		 end;
		{ Update the player's score and check for a winner. }
		writeln ;
		if NewPoints = 0 then
			writeln(P.Name, ' still has ', P.Points, ' points.')
		else
		 begin
			P.Points := P.Points + NewPoints;
			writeln(P.Name, ' now has ', P.Points, ' points total.');
			P.Victory := P.Points >= WinningScore
		 end
	end;

procedure Congratulate(Winner: Player);
	begin
		writeln ;
		write('Congratulations, ', Winner.Name, '! ');
		writeln('You won with ', Winner.Points, ' points.');
		writeln
	end;

begin
	{ Greet the players and initialize their data. }
	writeln('Let''s play Pig!');
	
	writeln ;
	write('Player 1, what is your name? ');
	readln(Player1.Name);
	Player1.Points := 0;
	Player1.Victory := false;
	
	writeln ;
	write('Player 2, what is your name? ');
	readln(Player2.Name);
	Player2.Points := 0;
	Player2.Victory := false;
	
	{ Take turns until there is a winner. }
	randomize;
	repeat
		TakeTurn(Player1);
		if not Player1.Victory then TakeTurn(Player2)
	until Player1.Victory or Player2.Victory;
	
	{ Announce the winner. }
	if Player1.Victory then
		Congratulate(Player1)
	else
		Congratulate(Player2)
end.
