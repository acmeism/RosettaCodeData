INT trials=100 000;

PROC brand = (INT n)INT: 1 + ENTIER (n * random);

PROC percent = (REAL x)STRING: fixed(100.0*x/trials,0,2)+"%";

main:
(
  INT prize, choice, show, not shown, new choice;
  INT stay winning:=0, change winning:=0, random winning:=0;
  INT doors = 3;
  [doors-1]INT other door;

  TO trials DO
     # put the prize somewhere #
     prize := brand(doors);
     # let the user choose a door #
     choice := brand(doors);
     # let us take a list of unchoosen doors #
     INT k := LWB other door;
     FOR j TO doors DO
        IF j/=choice THEN other door[k] := j; k+:=1 FI
     OD;
     # Monty opens one... #
     IF choice = prize THEN
     # staying the user will win... Monty opens a random port#
       show := other door[ brand(doors - 1) ];
       not shown := other door[ (show+1) MOD (doors - 1 ) + 1]
     ELSE # no random, Monty can open just one door... #
       IF other door[1] = prize THEN
           show := other door[2];
           not shown := other door[1]
       ELSE
           show := other door[1];
           not shown := other door[2]
       FI
     FI;

     # the user randomly choose one of the two closed doors
        (one is his/her previous choice, the second is the
        one not shown ) #
     other door[1] := choice;
     other door[2] := not shown;
     new choice := other door[ brand(doors - 1) ];
     # now let us count if it takes it or not #
     IF choice = prize THEN stay winning+:=1 FI;
     IF not shown = prize THEN change winning+:=1 FI;
     IF new choice = prize THEN random winning+:=1 FI
  OD;

  print(("Staying: ", percent(stay winning), new line ));
  print(("Changing: ", percent(change winning), new line ));
  print(("New random choice: ", percent(random winning), new line ))
)
