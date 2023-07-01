MODE YEAR = INT, MONTH = INT, DAY = INT;

PROC year days = (YEAR year)DAY: # Ignore 1752 CE for the moment #
  ( month days(year, 2) = 28 | 365 | 366 );

PROC month days = (YEAR year, MONTH month) DAY:
  ( month | 31,
            28 + ABS (year MOD 4 = 0 AND year MOD 100 /= 0 OR year MOD 400 = 0),
            31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

PROC is leap year = (YEAR year)BOOL: year days(year)=366;

test:(
  []INT test cases = (1900, 1994, 1996, 1997, 2000);
  FOR i TO UPB test cases DO
    YEAR year = test cases[i];
    printf(($g(0)" is "b("","not ")"a leap year."l$, year, is leap year(year)))
  OD
)
