COBOL *> days-between
      *> Tectonics: cobc -xj days-between.cob

       identification division.
       program-id. days-between.

       procedure division.
       compute tally =
         function integer-of-formatted-date('YYYY-MM-DD', '2019-11-24')
         -
         function integer-of-formatted-date('YYYY-MM-DD', '2000-01-01')
       display tally

       compute tally =
         function integer-of-formatted-date('YYYYMMDD', '20191124')
         -
         function integer-of-formatted-date('YYYYMMDD', '20000101')
       display tally

       goback.
       end program days-between.
