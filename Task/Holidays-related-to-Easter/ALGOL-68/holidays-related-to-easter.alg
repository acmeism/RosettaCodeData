MODE YEAR = INT, MONTH = INT, WEEK = INT, DAY = INT;

MODE DATE = STRUCT(
  YEAR year,  #DAY year day, #
  MONTH month, DAY month day,#
  WEEK week,  #DAY week day);

FORMAT mon fmt =      $c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")$,
FORMAT week day fmt = $c("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri")$;

PROC year days = (YEAR year)DAY: # Ignore 1752 CE for the moment #
  ( month days(year, 2) = 28 | 365 | 366 );

PROC month days = (YEAR year, MONTH month) DAY:
  ( month | 31,
            28 + ABS (year MOD 4 = 0 AND year MOD 100 /= 0 OR year MOD 400 = 0),
            31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

MONTH year months = 12;
DAY week days = 7; # France 1793 to 1805 had 10 day weeks! #

OP + = (DATE in date, DAY in days)DATE:
    BEGIN # todo: eliminate loops, handle year <= 1752 #
       DAY days := in days;
       DATE date := in date;
    # Normalize the days to be less then 1 year #
       WHILE days < 0 DO
         year OF date -:= 1;
         days +:= year days(year OF date)
       OD;
       WHILE days > year days(year OF date) DO
         days -:= year days(year OF date);
         year OF date +:= 1
       OD;
       month day OF date +:= days;
    # Normalize the days to be the same month #
       WHILE month day OF date > month days(year OF date, month OF date) DO
          month day OF date -:= month days(year OF date, month OF date);
          month OF date +:= 1;
          IF month OF date > year months THEN
             month OF date -:= year months;
             year OF date +:= 1
          FI
       OD;
       week day OF date := week day(date);
       date
    END;

OP +:= = (REF DATE date, DAY in days)DATE:
   date := date + in days;

PROC easter = (YEAR year)DATE:
   BEGIN
      COMMENT
         Easter date algorithm from J.M. Oudin (1940), reprinted in:
         P.K. Seidelmann ed., "Explanatory Supplement to the Astronomical
         Almanac" [1992] (Chapter 12, "Calendars", by L.E. Doggett)
      COMMENT
      DATE date; year OF date := year;
      INT c = year OVER 100, n = year MOD 19; # 19 years: Metonic cycle #
      INT i := (c - c OVER 4 - (c - (c - 17) OVER 25) OVER 3 + 19 * n + 15) MOD 30;
      i -:= (i OVER 28) * (1 - (i OVER 28) * (29 OVER (i + 1)) * ((21 - n) OVER 11));
      INT l = i - (year + year OVER 4 + i + 2 - c + c OVER 4) MOD 7;
      month OF date := 3 + (l + 40) OVER 44;
      month day OF date := l + 28 - 31 * (month OF date OVER 4);
      week day OF date := week day(date);
      date
   END;

PROC week day = (DATE date)DAY:
   # Zeller’s Congruence algorithm from 1887. #
   BEGIN
      INT year := year OF date, month := month OF date, month day := month day OF date, c;
      (month <= 2 | (month +:= 12, year -:= 1));
      c := year OVER 100;
      year MODAB 100;
      1 + (month day + ((month + 1) * 26) OVER 10
         + year + year OVER 4 + c OVER 4 - 2 * c) MOD 7
   END;

FORMAT wdmdm fmt = $f(week day fmt)z-dxf(mon fmt)$,

MODE EASTERRELATED = STRUCT(DATE easter, ascension, pentecost, trinity, corpus christi);

PROC easter related init = (YEAR year)EASTERRELATED:
BEGIN
  DATE date;
  EASTERRELATED holidays;
# Easter date, always a Sunday. #
   easter OF holidays := date := easter(year);
# Ascension day is 39 days after Easter.#
   ascension OF holidays := ( date +:= 39);
# Pentecost is 10 days after Ascension day.#
   pentecost OF holidays := date +:= 10;
# Trinity is 7 days after Pentecost.#
   trinity OF holidays := date +:= 7;
# Corpus Christi is 4 days after Trinity.#
   corpus christi OF holidays := date +:= 4;
   holidays
END;

# Note: Y10K bug here... :-) #
FORMAT easter related fmt = $g(-4)" Easter: "f(wdmdm fmt) ", Ascension: "f(wdmdm fmt)
    ", Pentecost: "f(wdmdm fmt) ", Trinity: "f(wdmdm fmt)", Corpus: "f(wdmdm fmt)$;

PROC easter related print = (YEAR year)VOID:
BEGIN
  EASTERRELATED holidays = easter related init(year);
  PROC wdmdm = (DATE date)STRUCT(DAY week day, DAY month day, MONTH month):
    (week day OF date, month day OF date, month OF date);
  printf((easter related fmt, year,
     wdmdm(easter OF holidays),  wdmdm(ascension OF holidays), wdmdm(pentecost OF holidays),
     wdmdm(trinity OF holidays), wdmdm(corpus christi OF holidays),
  $l$))
END;

printf (($"Christian holidays, related to Easter, for each centennial from 400 to 2100 CE:"l$));
FOR year FROM 400 BY 100 TO 2100 DO easter related print(year) OD;

printf (($l"Christian holidays, related to Easter, for years from 2010 to 2020 CE:"l$));
FOR year FROM 2010 TO 2020 DO easter related print(year) OD
