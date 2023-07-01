2 base !
: utf8+ ( str -- str )
  begin
    char+
    dup c@
    11000000 and
    10000000 <>
  until ;
decimal
