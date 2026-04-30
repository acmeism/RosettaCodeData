       identification division.
       program-id. box-compass.
       data division.
       working-storage section.
       01 point                pic 99.
       01 degrees              usage float-short.
       01 degrees-rounded      pic 999v99.
       01 show-degrees         pic zz9.99.
       01 box                  pic z9.
       01 fudge                pic 9.
       01 compass              pic x(4).
       01 compass-point        pic x(18).
       01 shortform            pic x.
       01 short-names.
          05 short-name        pic x(4) occurs 33 times.
       01 overlay.
          05 value "N   " & "NbE " & "N-NE" & "NEbN" & "NE  " &
                   "NEbE" & "E-NE" & "EbN " & "E   " & "EbS " &
                   "E-SE" & "SEbE" & "SE  " & "SEbS" & "S-SE" &
                   "SbE " & "S   " & "SbW " & "S-SW" & "SWbS" &
                   "SW  " & "SWbW" & "W-SW" & "WbS " & "W   " &
                   "WbN " & "W-NW" & "NWbW" & "NW  " & "NWbN" &
                   "N-NW" & "NbW " & "N   ".

       procedure division.
       display "Index Compass point      Degree"

       move overlay to short-names.
       perform varying point from 0 by 1 until point > 32
           compute box = function mod(point 32) + 1
           compute degrees = point * 11.25
           compute fudge = function mod(point 3)
           evaluate fudge
              when equal 1
                  add 5.62 to degrees
              when equal 2
                  subtract 5.62 from degrees
           end-evaluate

           compute degrees-rounded rounded = degrees
           move degrees-rounded to show-degrees
           inspect show-degrees replacing trailing '00' by '0 '
           inspect show-degrees replacing trailing '50' by '5 '

           move short-name(point + 1) to compass
           move spaces to compass-point
           display space box space space space with no advancing
           perform varying tally from 1 by 1 until tally > 4
               move compass(tally:1) to shortform
               move function concatenate(function trim(compass-point),
                    function substitute(shortform,
                        "N", "North",
                        "E", "East",
                        "S", "South",
                        "W", "West",
                        "b", " byZ",
                        "-", "-"))
                 to compass-point
           end-perform
           move function substitute(compass-point, "Z", " ")
             to compass-point
           move function lower-case(compass-point) to compass-point
           move function upper-case(compass-point(1:1))
             to compass-point(1:1)
           display compass-point space show-degrees
       end-perform
       goback.
