program attributes;

var
   total, roll,score, count: integer;
   atribs : array [1..6] of integer;

begin
    randomize; {Initalise the random number genertor}
    repeat
        count:=0;
        total:=0;
        for score :=1 to 6 do begin
           {roll:=random(18)+1;   produce a number up to 18, pretty much the same results}
           for diceroll:=1 to 4 do dice[diceroll]:=random(6)+1; {roll 4 six sided die}

           {find lowest rolled dice. If we roll two or more equal low rolls then we
	    eliminate the first of them, change '<' to '<=' to eliminate last low die}
           lowroll:=7;
	   lowdie:=0;
	   for diceroll:=1 to 4 do if (dice[diceroll] < lowroll) then begin
	       lowroll := dice[diceroll];
	       lowdie := diceroll;
	   end;
           {add up higest three dice}
	   roll:=0;
	   for diceroll:=1 to 4 do if (diceroll <> lowdie) then roll := roll + dice[diceroll];
           atribs[score]:=roll;
           total := total + roll;
           if (roll>15) then count:=count+1;
        end;
   until ((total>74) and (count>1)); {this evens out different rolling methods }
   { Prettily print the attributes out }
   writeln('Attributes :');
   for count:=1 to 6 do
      writeln(count,'.......',atribs[count]:2);
   writeln('       ---');
   writeln('Total  ',total:3);
   writeln('       ---');
end.
