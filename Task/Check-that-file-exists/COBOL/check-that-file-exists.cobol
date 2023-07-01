       identification division.
       program-id. check-file-exist.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 skip                 pic 9 value 2.
       01 file-name.
          05 value "/output.txt".
       01 dir-name.
          05 value "/docs/".
       01 unusual-name.
          05 value "Abdu'l-Bahá.txt".

       01 test-name            pic x(256).

       01 file-handle          usage binary-long.
       01 file-info.
          05 file-size         pic x(8) comp-x.
          05 file-date.
             10 file-day       pic x comp-x.
             10 file-month     pic x comp-x.
             10 file-year      pic xx comp-x.
          05 file-time.
             10 file-hours     pic x comp-x.
             10 file-minutes   pic x comp-x.
             10 file-seconds   pic x comp-x.
             10 file-hundredths  pic x comp-x.

       procedure division.
       files-main.

      *> check in current working dir
       move file-name(skip:) to test-name
       perform check-file

       move dir-name(skip:) to test-name
       perform check-file

       move unusual-name to test-name
       perform check-file

      *> check in root dir
       move 1 to skip
       move file-name(skip:) to test-name
       perform check-file

       move dir-name(skip:) to test-name
       perform check-file

       goback.

       check-file.
       call "CBL_CHECK_FILE_EXIST" using test-name file-info
       if return-code equal zero then
           display test-name(1:32) ": size " file-size ", "
                   file-year "-" file-month "-" file-day space
                   file-hours ":" file-minutes ":" file-seconds "."
                   file-hundredths
       else
           display "error: CBL_CHECK_FILE_EXIST " return-code space
                   trim(test-name)
       end-if
       .

       end program check-file-exist.
