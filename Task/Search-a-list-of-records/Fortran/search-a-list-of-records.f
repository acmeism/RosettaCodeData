      MODULE SEMPERNOVIS	!Keep it together.
       TYPE CITYSTAT		!Define a compound data type.
        CHARACTER*28	NAME		!Long enough?
        REAL		POPULATION	!Accurate enough.
       END TYPE CITYSTAT	!Just two parts, but different types.
       TYPE(CITYSTAT) CITY(10)	!Righto, I'll have some.
       DATA CITY/		!Supply the example's data.
     1   CITYSTAT("Lagos",               21.0 ),
     2   CITYSTAT("Cairo",               15.2 ),
     3   CITYSTAT("Kinshasa-Brazzaville",11.3 ),
     4   CITYSTAT("Greater Johannesburg", 7.55),
     5   CITYSTAT("Mogadishu",            5.85),
     6   CITYSTAT("Khartoum-Omdurman",    4.98),
     7   CITYSTAT("Dar Es Salaam",        4.7 ),
     8   CITYSTAT("Alexandria",           4.58),
     9   CITYSTAT("Abidjan",              4.4 ),
     o   CITYSTAT("Casablanca",           3.98)/
       CONTAINS
        INTEGER FUNCTION FIRSTMATCH(TEXT,TARGET)	!First matching.
         CHARACTER*(*) TEXT(:)	!An array of texts.
         CHARACTER*(*) TARGET	!The text to look for.
          DO FIRSTMATCH = 1,UBOUND(TEXT,DIM = 1)	!Scan the array from the start.
            IF (TEXT(FIRSTMATCH) .EQ. TARGET) RETURN	!An exact match? Ignoring trailing spaces.
          END DO				!Try the next.
          FIRSTMATCH = 0		!No match. Oh dear.
        END FUNCTION FIRSTMATCH

        INTEGER FUNCTION FIRSTLESS(VAL,TARGET)	!First matching.
         REAL VAL(:)	!An array of values.
         REAL TARGET	!The value to look for.
          DO FIRSTLESS = 1,UBOUND(VAL,DIM = 1)	!Step through the array from the start.
            IF (VAL(FIRSTLESS) .LT. TARGET) RETURN	!Suitable?
          END DO				!Try the next.
          FIRSTLESS = 0		!No match. Oh dear.
        END FUNCTION FIRSTLESS
      END MODULE SEMPERNOVIS

      PROGRAM POKE
      USE SEMPERNOVIS	!Ex Africa, ...
      CHARACTER*(*) BLAH	!Save on some typing.
      PARAMETER (BLAH = "The first city in the list whose ")	!But also, for layout.

      WRITE (6,1) BLAH,FIRSTMATCH(CITY.NAME,"Dar Es Salaam") - 1	!My array starts with one.
    1 FORMAT (A,"name is Dar Es Salaam, counting with zero, is #",I0)

      WRITE (6,2) BLAH,CITY(FIRSTLESS(CITY.POPULATION,5.0)).NAME
    2 FORMAT (A,"population is less than 5 is ",A)

      WRITE (6,3) BLAH,CITY(FIRSTMATCH(CITY.NAME(1:1),"A")).POPULATION
    3 FORMAT (A,"whose name starts with A has population",F5.2)
      END
