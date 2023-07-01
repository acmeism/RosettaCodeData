      *>
      *> Kernighan large earthquake problem
      *> Tectonics: cobc -xj kernighan-earth-quakes.cob
      *>            quakes.txt with the 3 sample lines
      *>            ./kernighan-earth-quakes
      *>
       >>SOURCE FORMAT IS FREE
       identification division.
       program-id. quakes.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select quake-data
           assign to command-filename
           organization is line sequential
           status is quake-fd-status
           .

       data division.
       file section.
       fd quake-data record varying depending on line-length.
           01 data-line       pic x(32768).

       working-storage section.
       01 quake-fd-status pic xx.
          88 ok values "00", "01", "02", "03", "04",
                       "05", "06", "07", "08", "09".
          88 no-more value "10".
          88 io-error value high-value.

       01 line-length usage binary-long.

       01 date-time pic x(10).
       01 quake pic x(20).
       01 magnitude pic 99v99.

       01 command-filename pic x(80).

       procedure division.
       show-big-ones.

       accept command-filename from command-line
       if command-filename equal spaces then
           move "data.txt" to command-filename
       end-if

       open input quake-data
       perform status-check
       if io-error then
           display trim(command-filename) " not found" upon syserr
           goback
       end-if

       read quake-data
       perform status-check
       perform until no-more or io-error
           unstring data-line delimited by all spaces
              into date-time quake magnitude
           end-unstring

           if magnitude greater than 6
               display date-time space quake space magnitude
           end-if

           read quake-data
           perform status-check
       end-perform

       close quake-data
       perform status-check
       goback.
      *> ****

       status-check.
       if not ok and not no-more then   *> not normal status, bailing
           display "io error: " quake-fd-status upon syserr
           set io-error to true
       end-if
       .

       end program quakes.
