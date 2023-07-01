      *> Rosetta Code fixed length records, text to Forth block
       identification division.
       program-id. blocking.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select infile
               assign to infile-name
               organization is line sequential
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
           01 input-text pic x(64).

       fd outfile.
           01 output-text pic x(64).

       working-storage section.
       01 infile-name.
          05 value "forth.txt".
       01 infile-status pic xx.
          88 ok-input value '00'.
          88 eof-input value '10'.

       01 outfile-name.
          05 value "forth.blk".
       01 outfile-status pic xx.
          88 ok-output value '00'.

       procedure division.

      *> read a line, padded to or truncated at 64 as defined in FD
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

       move 0 to tally
       read infile
       perform until not ok-input
           move input-text to output-text

           write output-text
           if not ok-output then
               display "error writing: " output-text upon syserr
           end-if

           add 1 to tally
           if tally > 15 then move 0 to tally end-if

           read infile
       end-perform

      *> Output up to next 1024 byte boundary
       if tally > 0 then
           compute tally = 16 - tally
           move spaces to output-text

           perform tally times
               write output-text
               if not ok-output then
                   display "error writing: " output-text upon syserr
               end-if
           end-perform
       end-if

       close infile outfile

       goback.
       end program blocking.
