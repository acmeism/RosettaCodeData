       identification division.
       program-id. wr-float.
       environment division.
       input-output section.
       file-control.
           select report-file assign "float.txt"
               organization sequential.
       data division.
       file section.
       fd report-file
           report is floats.
       working-storage section.
       1 i binary pic 9(4).
       1 x-values comp-2.
        2 value 1.0.
        2 value 2.0.
        2 value 3.0.
        2 value 1.0e11.
       1 redefines x-values comp-2.
        2 x occurs 4.
       1 comp-2.
        2 y occurs 4.
       report section.
       rd floats.
       1 float-line type de.
        2 line plus 1.
         3 column 1 pic -9.99e+99 source x(i).
         2 column 12 pic -9.9999e+99 source y(i).
       procedure division.
       begin.
           open output report-file
           initiate floats
           perform varying i from 1 by 1
           until i > 4
               compute y(i) = function sqrt (x(i))
               generate float-line
           end-perform
           terminate floats
           close report-file
           stop run
           .
       end program wr-float.
