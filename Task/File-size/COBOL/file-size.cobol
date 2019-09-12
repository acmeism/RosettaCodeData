       identification division.
       program-id. FileInfo.

       data division.
       working-storage section.
       01  file-name              pic x(256).
       01  file-size-edited       pic zzz,zzz,zzz.
       01  file-details.
           05 file-size           pic x(8) comp-x.
           05 file-date.
              10 file-day         pic x comp-x.
              10 file-month       pic x comp-x.
              10 file-year        pic xx comp-x.
           05 file-time.
              10 file-hour        pic x comp-x.
              10 file-minute      pic x comp-x.
              10 file-second      pic x comp-x.
              10 file-hundredths  pic x comp-x.

       procedure division.
       main.
           move "input.txt" to file-name
           perform file-info

           move "\input.txt" to file-name
           perform file-info

           stop run
           .

       file-info.
           call "CBL_CHECK_FILE_EXIST"
              using file-name, file-details
              returning return-code
           if return-code = 0
              move file-size to file-size-edited
              display function trim(file-name) " "
                      function trim(file-size-edited) " Bytes"
           else
              display function trim(file-name) " not found!"
           end-if
           .
