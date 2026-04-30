      *> Rosetta Code, fixed length records
      *> Tectonics:
      *>   cobc -xj lrecl80.cob
       identification division.
       program-id. lrecl80.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select infile
               assign to infile-name
               organization is sequential
               file status is infile-status
           .
           select outfile
               assign to outfile-name
               organization is sequential
               file status is outfile-status
           .

       data division.
       file section.
       fd infile.
           01 input-text pic x(80).

       fd outfile.
           01 output-text pic x(80).

       working-storage section.
       01 infile-name.
          05 value "infile.dat".
       01 infile-status pic xx.
          88 ok-input value '00'.
          88 eof-input value '10'.

       01 outfile-name.
          05 value "outfile.dat".
       01 outfile-status pic xx.
          88 ok-output value '00'.

       procedure division.

       open input infile
       if not ok-input then
           display "error opening input " infile-name upon syserr
           goback
       end-if

       open output outfile
       if not ok-output
           display "error opening output " outfile-name upon syserr
           goback
       end-if

      *> read lrecl 80 and write the reverse as lrecl 80
       read infile
       perform until not ok-input
           move function reverse(input-text) to output-text

           write output-text
           if not ok-output then
               display "error writing: " output-text upon syserr
           end-if
           read infile
       end-perform

       close infile outfile

      *> from fixed length to normal text, outfile is now the input file
       open input outfile
       if not ok-output then
           display "error opening input " outfile-name upon syserr
           goback
       end-if

       read outfile
       perform until not ok-output
           display function trim(output-text trailing)
           read outfile
       end-perform

       close outfile

       goback.
       end program lrecl80.
