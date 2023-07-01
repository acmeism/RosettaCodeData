#!/usr/local/bin/a68g --script #

PROC strip chars = (STRING mine, ore)STRING: (
  STRING out := "";
  FOR i FROM LWB mine TO UPB mine DO
    IF NOT char in string(mine[i], LOC INT, ore) THEN
      out +:= mine[i]
    FI
  OD;
  out[@LWB mine]
);

printf(($gl$,stripchars("She was a soul stripper. She took my heart!","aei")))
