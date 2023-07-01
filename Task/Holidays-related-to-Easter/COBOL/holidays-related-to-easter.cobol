       identification division.
       program-id. Easter.

       environment division.
       configuration section.
       repository.
           function date-of-integer intrinsic
           function integer-of-date intrinsic
           function mod intrinsic.

       data division.
       working-storage section.
       77  days                   pic 9(2).
       77  a                      pic 9(2).
       77  b                      pic 9(2).
       77  c                      pic 9(2).
       77  d                      pic 9(2).
       77  e                      pic 9(2).
       77  f                      pic 9(2).
       77  g                      pic 9(2).
       77  h                      pic 9(2).
       77  i                      pic 9(2).
       77  k                      pic 9(2).
       77  l                      pic 9(2).
       77  m                      pic 9(2).
       77  week-day               pic 9(1).
       77  numerator              pic 9(4).
       77  integer-date           pic 9(18).

       01  month-tab              value "JanFebMarAprMayJunJulAugSepOctNovDec".
           05 month-abreviated    pic x(3) occurs 12.

       01  week-day-tab           value "SunMonTueWedThuFriSat".
           05 week-day-abreviated pic x(3) occurs 7.

       01  easter-date            pic 9(8).
       01  filler redefines easter-date.
           05 easter-year         pic 9(4).
           05 easter-month        pic 9(2).
           05 easter-day          pic 9(2).

       01  holiday-date           pic 9(8).
       01  filler redefines holiday-date.
           05 holiday-year        pic 9(4).
           05 holiday-month       pic 9(2).
           05 holiday-day         pic 9(2).

       01  edt-date.
           05 edt-week-day        pic x(3).
           05 filler              pic x value space.
           05 edt-day             pic z(2).
           05 filler              pic x value space.
           05 edt-month           pic x(3).

       procedure division.
       main.
           display "Christian holidays, related to Easter, for each centennial from 1700 to 2100 CE:"
           perform varying easter-year from 1700 by 100 until easter-year > 2100
              perform output-holydays
           end-perform
           display " "

           display "Christian holidays, related to Easter, for years from 2010 to 2020 CE:"
           perform varying easter-year from 2010 by 1 until easter-year > 2020
              perform output-holydays
           end-perform
           display " "

           stop run
           .
       output-holydays.
           display easter-year " " no advancing
           perform calculate-easter

           move 0 to days
           perform add-days
           display " Easter: " edt-date no advancing

           move 39 to days
           perform add-days
           display " Ascension: " edt-date no advancing

           move 49 to days
           perform add-days
           display " Pentecost: " edt-date no advancing

           move 56 to days
           perform add-days
           display " Trinity: " edt-date no advancing

           move 60 to days
           perform add-days
           display " Corpus: " edt-date
           .
       calculate-easter.
           compute a = mod(easter-year, 19)
           compute b = easter-year / 100
           compute c = mod(easter-year, 100)
           compute d = b / 4
           compute e = mod(b, 4)
           compute f = (b + 8) / 25
           compute g = (b - f + 1) / 3
           compute h = mod((19 * a + b - d - g + 15), 30)
           compute i = c / 4
           compute k = mod(c, 4)
           compute l = mod((32 + 2 * e + 2 * i - h - k), 7)
           compute m = (a + 11 * h + 22 * l) / 451
           compute numerator = h + l - 7 * m + 114
           compute easter-month = numerator / 31
           compute easter-day = mod(numerator, 31) + 1
           .
       add-days.
           if days = 0
              move easter-date to holiday-date
              move 1 to week-day
           else
              compute holiday-date = date-of-integer(integer-of-date(easter-date) + days)
              compute week-day = mod(integer-of-date(easter-date) + days, 7) + 1
           end-if
           move week-day-abreviated(week-day) to edt-week-day
           move month-abreviated(holiday-month) to edt-month
           move holiday-day to edt-day
           .
