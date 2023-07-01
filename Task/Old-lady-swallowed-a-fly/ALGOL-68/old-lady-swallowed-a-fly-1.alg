#!/usr/local/bin/a68g --script #

STRING sw=" swallow ",swd=sw[:UPB sw-1]+"ed ", tsa=". To"+sw+"a";

INT count prev := 0; [9]STRING prev;

PROC vs = (STRING in wot,[]STRING co)VOID: (
  STRING wot = " "+in wot;
  printf(($g$,"I know an old lady who",swd,"a",wot,".",$l$));
  IF UPB co = 1 THEN
    printf(($gl$,co))
  ELIF UPB co > 1 THEN
    printf(($g$,co,wot+".",$l$))
  FI;
  IF count prev NE UPB prev THEN
    prev[count prev+:=1]:=wot;
    FOR i FROM count prev BY -1 TO 2 DO
      printf(($gl$,"She"+swd+"the"+prev[i]+" to catch the"+prev[i-1]+"."))
    OD;
    printf(($gl$,"I don't know why she"+swd+"the fly.",
                 "Perhaps she'll die.", $l$))
  FI
);

vs("fly",());
vs("spider","That wriggled and jiggled and tickled inside her.");
vs("Bird",("Quite absurd",tsa));
vs("Cat",("Fancy that",tsa));
vs("Dog",("What a hog",tsa));
vs("Pig",("Her mouth was so big",tsa));
vs("Goat",("She just opened her throat",tsa));
vs("Cow",("I don't know how",tsa));
vs("Donkey",("It was rather wonky",tsa));
vs("Horse","She's dead, of course!")
