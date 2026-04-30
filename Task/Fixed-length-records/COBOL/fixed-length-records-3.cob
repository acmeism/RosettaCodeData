      *> Rosetta Code fixed length records, Forth blocks to text.
       identification division.
       program-id. unblocking.

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
               organization is line sequential
               file status is outfile-status
           .

       data division.
       file section.
       fd infile.
           01 input-text pic x(64).

       fd outfile.
           01 output-text pic x(64).

       working-storage section.
       01 infile-name.
          05 value "forth.blk".
       01 infile-status pic xx.
          88 ok-input value '00'.
          88 eof-input value '10'.

       01 outfile-name.
          05 value "forth.txt".
       01 outfile-status pic xx.
          88 ok-output value '00'.

       procedure division.

       open input infile
       if not ok-input then
           display "error opening input " trim(infile-name) upon syserr
           goback
       end-if

       open output outfile
       if not ok-output
           display "error opening write " trim(outfile-name) upon syserr
           goback
       end-if

      *> read a fixed length line, 64 characters
       read infile
       perform until not ok-input
           move trim(input-text) to output-text

           write output-text
           if not ok-output then
               display "error writing: " output-text upon syserr
           end-if
           read infile
       end-perform

       close infile outfile

       goback.
       end program unblocking.
