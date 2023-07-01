       identification division.
       program-id. copyfile.
       environment division.
       input-output section.
       file-control.
           select input-file assign to "input.txt"
               organization sequential
           .
           select output-file assign to "output.txt"
               organization sequential
           .
       data division.
       file section.
       fd input-file.
       1 input-record pic x(80).
       fd output-file.
       1 output-record pic x(80).
       working-storage section.
       1 end-of-file-flag pic 9 value 0.
         88 eof value 1.
       1 text-line pic x(80).
       procedure division.
       begin.
           open input input-file
               output output-file
           perform read-input
           perform until eof
               write output-record from text-line
               perform read-input
           end-perform
           close input-file output-file
           stop run
           .
       read-input.
           read input-file into text-line
           at end
               set eof to true
           end-read
           .
       end program copyfile.
