INT trials = 10000;
INT t total := 0, s total := 0;

print(("Seconds  steps behind  steps ahead", new line));

FOR i TO trials DO
  INT stairs := 100, location := 0, seconds := 0;
  DO
    seconds +:= 1;
    location +:= 1;
    IF location > stairs THEN break FI;
    TO 5 DO
      INT roll = ENTIER (next random * stairs + 1);
      IF roll <= location THEN location +:= 1 FI;
      stairs +:= 1
    OD;
    IF i = 1 AND seconds >= 600 AND seconds <= 609 THEN
      print(("  ",        whole(seconds, 0),
             "        ",  whole(location, 0),
             "         ", whole(stairs-location, 0),
             new line))
    FI
  OD;
  break:
  t total +:= seconds;
  s total +:= stairs
OD;

print(("Average seconds: ",  fixed(t total / trials, 0, 4),
       ",  Average steps: ", fixed(s total / trials, 0, 4),
       new line))
