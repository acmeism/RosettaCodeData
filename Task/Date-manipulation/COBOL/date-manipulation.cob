       identification division.
       program-id. date-manipulation.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 given-date.
          05 filler            value z"March 7 2009 7:30pm EST".
       01 date-spec.
          05 filler            value z"%B %d %Y %I:%M%p %Z".

       01 time-struct.
          05 tm-sec            usage binary-long.
          05 tm-min            usage binary-long.
          05 tm-hour           usage binary-long.
          05 tm-mday           usage binary-long.
          05 tm-mon            usage binary-long.
          05 tm-year           usage binary-long.
          05 tm-wday           usage binary-long.
          05 tm-yday           usage binary-long.
          05 tm-isdst          usage binary-long.
          05 tm-gmtoff         usage binary-c-long.
          05 tm-zone           usage pointer.
       01 scan-index           usage pointer.

       01 time-t               usage binary-c-long.
       01 time-tm              usage pointer.

       01 reform-buffer        pic x(64).
       01 reform-length        usage binary-long.

       01 current-locale       usage pointer.

       01 iso-spec             constant as "YYYY-MM-DDThh:mm:ss+hh:mm".
       01 iso-date             constant as "2009-03-07T19:30:00-05:00".
       01 date-integer         pic 9(9).
       01 time-integer         pic 9(9).

       procedure division.

       call "strptime" using
           by reference given-date
           by reference date-spec
           by reference time-struct
           returning scan-index
           on exception
               display "error calling strptime" upon syserr
       end-call
       display "Given: " given-date

       if scan-index not equal null then
           *> add 12 hours, and reform as local
           call "mktime" using time-struct returning time-t
           add 43200 to time-t
           perform form-datetime

           *> reformat as Pacific time
           set environment "TZ" to "PST8PDT"
           call "tzset" returning omitted
           perform form-datetime

           *> reformat as Greenwich mean
           set environment "TZ" to "GMT"
           call "tzset" returning omitted
           perform form-datetime


           *> reformat for Tokyo time, as seen in Hong Kong
           set environment "TZ" to "Japan"
           call "tzset" returning omitted
           call "setlocale" using by value 6 by content z"en_HK.utf8"
               returning current-locale
               on exception
                   display "error with setlocale" upon syserr
           end-call
           move z"%c" to date-spec
           perform form-datetime
       else
           display "date parse error" upon syserr
       end-if

      *> A more standard COBOL approach, based on ISO8601
       display "Given: " iso-date
       move integer-of-formatted-date(iso-spec, iso-date)
         to date-integer

       move seconds-from-formatted-time(iso-spec, iso-date)
         to time-integer

       add 43200 to time-integer
       if time-integer greater than 86400 then
           subtract 86400 from time-integer
           add 1 to date-integer
       end-if
       display "       " substitute(formatted-datetime(iso-spec
                   date-integer, time-integer, -300), "T", "/")

       goback.

       form-datetime.
       call "localtime" using time-t returning time-tm
       call "strftime" using
           by reference reform-buffer
           by value length(reform-buffer)
           by reference date-spec
           by value time-tm
           returning reform-length
           on exception
               display "error calling strftime" upon syserr
       end-call
       if reform-length > 0 and <= length(reform-buffer) then
           display "       " reform-buffer(1 : reform-length)
       else
           display "date format error" upon syserr
       end-if
       .
       end program date-manipulation.
