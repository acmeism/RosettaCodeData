       identification division.
       program-id. circle.
       environment division.
       input-output section.
       file-control.
           select plot-file assign "circle.txt".
       data division.
       file section.
       fd plot-file report plot.
       working-storage section.
       1 binary.
        2 seed pic 9(18).
        2 x pic s9(4).
        2 y pic s9(4).
        2 i pic 9(4).
        2 dot-count pic 9(4) value 0.
        2 dot-count-save pic 9(4) value 0.
        2 temp-points.
         3 pic s9(4) occurs 2.
        2 xy-table.
         3 point-pair occurs 0 to 404 depending dot-count.
          4 x-point pic s9(4).
          4 y-point pic s9(4).
       1 plot-table value all "0".
        2 occurs 31.
         3 dot pic 9 occurs 31.
       1 cur-date-time.
        2 yyyymmdd pic 9(8).
        2 hh pic 9(2).
        2 mm pic 9(2).
        2 ss pic 9(2).
       1 plot-work.
        2 plot-item pic xb occurs 31.
       report section.
       rd plot.
       1 plot-line type de.
        2 line plus 1.
         3 column is 1 source is plot-work pic x(62).
       procedure division.
       begin.
           perform compute-seed
           perform find-all-valid-points
           perform shuffle-point-pairs
           perform select-100-dots
           perform print-dots
           stop run
           .

       find-all-valid-points.
           perform varying x from -15 by 1 until x > +15
               perform varying y from -15 by 1 until y > +15
                   if (function sqrt (x ** 2 + y ** 2))
                       >= 10 and <= 15
                   then
                       move 1 to dot (x + 16 y + 16)
                       add 1 to dot-count
                       compute x-point (dot-count) = x + 16
                       compute y-point (dot-count) = y + 16
                   end-if
               end-perform
           end-perform
           display "Total points: " dot-count
           .

       shuffle-point-pairs.
           move dot-count to dot-count-save
           compute i = function random (seed) * dot-count + 1
           perform varying dot-count from dot-count by -1
           until dot-count < 2
               move point-pair (i) to temp-points
               move point-pair (dot-count) to point-pair (i)
               move temp-points  to point-pair (dot-count)
               compute i = function random * dot-count + 1
           end-perform
           move dot-count-save to dot-count
           .

       select-100-dots.
           perform varying i from 1 by 1
           until i > 100
               compute x = x-point (i)
               compute y = y-point (i)
               move 2 to dot (x y)
           end-perform
           .

       print-dots.
           open output plot-file
           initiate plot
           perform varying y from 1 by 1 until y > 31
               move spaces to plot-work
               perform varying x from 1 by 1 until x > 31
                   if dot (x y) = 2
                       move "o" to plot-item (x)
                   end-if
               end-perform
               generate plot-line
           end-perform
           terminate plot
           close plot-file
           .

       compute-seed.
           unstring function current-date into
               yyyymmdd hh mm ss
           compute seed =
               (function integer-of-date (yyyymmdd) * 86400)
           compute seed = seed
                 + (hh * 3600) + (mm * 60) + ss
           compute seed = function mod (seed 32768)
           .

       end program circle.
