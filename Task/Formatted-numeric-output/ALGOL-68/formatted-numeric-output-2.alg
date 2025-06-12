(
  OP UNSUPPRESS = ( STRING v )STRING: # replace leading spaces with zeros #
     IF   LWB v > UPB v
     THEN v # empty string #
     ELSE STRING result := v;
          INT    p1     := LWB result;
          IF result[ p1 ] = " " THEN result[ p1 ] := "0" FI;
          FOR p FROM LWB result + 1 TO UPB result DO
              CHAR c = result[ p ];
              IF   c = " "            THEN result[ p ] := "0"
              ELIF c = "-" OR c = "+" THEN result[ p ] := "0"; result[ p1 ] := c
              ELIF c = "e"            THEN p1 := p + 1
              FI
          OD;
          result
     FI # UNSUPPRESS # ;
  OP SUPPRESSPLUS = ( STRING v )STRING: # replace leading space/zero with "+" #
     IF LWB v > UPB v THEN v ELIF CHAR c = v[ LWB v ]; c = "+" OR c = "0" THEN " " + v[ LWB v + 1 : ] ELSE v FI;
  PRIO SUPPRESS = 5; # suppress up to d leading zeros #
  OP   SUPPRESS = ( STRING v, INT d )STRING:
       IF   LWB v > UPB v
       THEN v
       ELIF CHAR c1 = v[ LWB v ]; c1 /= "+" AND c1 /= "-" AND c1 /= "0"
       THEN v
       ELSE INT  len   = ( UPB v - LWB v ) + 1;
            INT  max p = ( LWB v - 1 ) + IF len > d THEN d ELSE len FI;
            STRING result := v;
            CHAR sign char = IF c1 = "0" THEN " " ELSE c1 FI;
            result[ LWB result ] := " ";
            BOOL inserted sign   := FALSE;
            FOR p FROM LWB result + 1 TO max p
            WHILE CHAR c = result[ p ];
                  IF c /= "0" THEN result[ p - 1 ] := sign char; inserted sign := TRUE FI;
                  NOT inserted sign
            DO result[ p ] := " "
            OD;
            IF NOT inserted sign THEN result[ max p ] := sign char FI;
            result
       FI # SUPPRESS # ;

  REAL r=exp(pi)-pi;
  print((r,newline));
  print((fixed(-r,16,4),newline));
  print((fixed(r,-16,4),newline));
  print((fixed(r,16,4),newline));
  print((float(r,16,4,1),newline));

  print((SUPPRESSPLUS UNSUPPRESS fixed(-r,-10,4),newline));
  print((SUPPRESSPLUS UNSUPPRESS fixed(r,-10,4),newline));
  print((UNSUPPRESS fixed(r,10,4),newline));
  print((UNSUPPRESS fixed(ABS r,-10,4),newline));

  print((fixed(ABS r,-10,4),newline));

  print((SUPPRESSPLUS UNSUPPRESS fixed(-r,12,4) SUPPRESS 5,newline));
  print((SUPPRESSPLUS UNSUPPRESS float(-r,16,4,-3) SUPPRESS 5,newline));
  print((SUPPRESSPLUS UNSUPPRESS float(-r,-13,4,3),newline));
  print((SUPPRESSPLUS UNSUPPRESS float(r,-17,4,5),newline))
)
