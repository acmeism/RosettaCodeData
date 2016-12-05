//In what years between 2008 and 2121 will the 25th of December be a Sunday?

IMPORT STD;

BaseYear := 2008;
EndYear  := 2121;

ChristmasDay := RECORD
  UNSIGNED1 DayofWeek;
  UNSIGNED2 Year;
END;

ChristmasDay FindDate(INTEGER Ctr) := TRANSFORM
  SELF.DayofWeek := (STD.Date.FromGregorianYMD((BaseYear-1) + Ctr,12,25)) % 7; //0=Sunday
  SELF.Year := (BaseYear-1) + Ctr;
END;

YearDS := DATASET(EndYear-BaseYear,FindDate(COUNTER));
OUTPUT(YearDS(DayofWeek=0),{Year});

/* Outputs:
   2011
   2016
   2022
   2033
   2039
   2044
   2050
   2061
   2067
   2072
   2078
   2089
   2095
   2101
   2107
   2112
   2118
*/
