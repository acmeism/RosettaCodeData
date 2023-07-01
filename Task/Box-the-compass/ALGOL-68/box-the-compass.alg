#!/usr/local/bin/a68g --script #

[]STRING
  long  by nesw = (" by ", "North", "East", "South", "West"),
  short by nesw = ("b", "N", "E", "S", "W");

MODE MINUTES = REAL; # minutes type #
INT last minute=360*60;
INT point width=last minute OVER 32;

PROC direction name = (REAL direction in minutes, []STRING locale directions)STRING: (

  STRING by = locale directions[1];
  []STRING nesw = locale directions[@-1];

  PRIO MASK = 7; # same PRIOrity as * and / #
  OP MASK = (INT n, BITS lower)INT: ABS (BIN n AND NOT lower),
     DECAP = (STRING s)STRING: IF UPB s > 1 THEN REPR (ABS s[1]-ABS "A"+ABS "a")+s[2:] ELSE s FI;

  PROC point name = (INT in point)STRING: (

    INT point = in point MOD 32 # 32 points of a compass #;
    IF point MOD 8 = 0 THEN
# name the principle point: eg. N, E, S or W #
      nesw[point OVER 8]

    ELIF point MOD 4 = 0 THEN
# name the half: eg. NE, SE, SW or NW #
      point name((point+8)MASK 2r1111)+DECAP point name(point MASK 2r1111 + 8)

    ELIF point MOD 2 = 0 THEN
# name the quarter: eg. N-NE, E-NE, E-SE, S-SE, S-SW, W-SW, W-NW or N-NW #
      point name((point+4)MASK 2r111)+"-"+point name(point MASK 2r111 + 4)

    ELSE # Name the sixteenth point: #
# eg. NbE,NEbN,NEbE,EbN,EbS,SEbE,SEbS,SbE,SbW,SWbS,SWbW,WbS,WbN,NWbW,NWbN,NbW #
      INT opp point = point OVER 8 + ABS NOT ODD (point OVER 2);
      point name((point+2)MASK 2r11)+ by +nesw(opp point MOD 4)
    FI
  );
  point name(ROUND(direction in minutes/point width))
);

PROC traditional name = (MINUTES minutes)STRING: (
  INT degrees = ROUND(minutes / 60);
  degrees=0  |"Tramontana"          |:
  degrees=45 |"Greco or Bora"       |:
  degrees=90 |"Levante"             |:
  degrees=135|"Sirocco"             |:
  degrees=180|"Ostro"               |:
  degrees=225|"Libeccio"            |:
  degrees=270|"Poniente or Zephyrus"|:
  degrees=315|"Mistral"             |:
  degrees=360|"Tramontana"          |""
);

# First generate the test set results #
test:(
  printf($"Test:"l$);
  FOR i FROM 0 TO 32 DO
    REAL heading = i * 11.25 +
      CASE i MOD 3 IN
        +5.62,
        -5.62
        OUT 0
      ESAC;
    INT index = ( i MOD 32) + 1;
    printf(($zd" ", g23k, zzd.zzl$, index , direction name(heading*60, long by nesw), heading))
  OD
);

table:(
  OP OVER = (REAL r, INT base)INT: ENTIER ABS r OVER  base,
     MOD = (REAL r, INT base)REAL: ( INT i = ENTIER r; i MOD base + r - i);

  printf(
    $l"Table:"l
    " #|Compass point"22k"|Abbr|Traditional wind point| Lowest°′ | Middle°′ | Highest°′"l$
  );

  OP DEGMIN = (REAL minutes)STRUCT(INT d, REAL m): (minutes MOD last minute OVER 60, minutes MOD 60);

  FOR point FROM 1 TO 32 DO
    REAL centre = (point-1) * point width;
    REAL from =  centre - point width/2,
         to   =  centre + point width/2-1/120;
    printf((
            $g(-2)"|"$, point,
            $g$, direction name(centre, long by nesw),
            $22k"|"g$, direction name(centre, short by nesw),
            $27k"|"g$, traditional name(centre),
            $50k$, $"|"g(-3)"°", dd.dd"′"$, DEGMIN from, DEGMIN centre, DEGMIN to,
            $l$
          ))
  OD
)
