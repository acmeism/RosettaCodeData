      *> Tectonics:
      *>   cobc -xj append.cob
      *>   cobc -xjd -DDEBUG append.cob
      *> ***************************************************************
       identification division.
       program-id. append.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select pass-file
           assign to pass-filename
           organization is line sequential
           status is pass-status.

       REPLACE ==:LRECL:== BY ==2048==.

       data division.
       file section.
       fd pass-file record varying depending on pass-length.
       01 fd-pass-record.
          05 filler pic x occurs 0 to :LRECL: times
                          depending on pass-length.

       working-storage section.
       01 pass-filename.
          05 filler            value "passfile".
       01 pass-status          pic xx.
          88 ok-status         values '00' thru '09'.
          88 eof-pass          value '10'.

       01 pass-length          usage index.
       01 total-length         usage index.

       77 file-action          pic x(11).

       01 pass-record.
          05 account           pic x(64).
             88 key-account    value "xyz".
          05 password          pic x(64).
          05 uid               pic z(4)9.
          05 gid               pic z(4)9.
          05 details.
             10 fullname       pic x(128).
             10 office         pic x(128).
             10 extension      pic x(32).
             10 homephone      pic x(32).
             10 email          pic x(256).
          05 homedir           pic x(256).
          05 shell             pic x(256).

       77 colon                pic x value ":".
       77 comma-mark           pic x value ",".
       77 newline              pic x value x"0a".

      *> ***************************************************************
       procedure division.
       main-routine.
       perform initial-fill

       >>IF DEBUG IS DEFINED
       display "Initial data:"
       perform show-records
       >>END-IF

       perform append-record

       >>IF DEBUG IS DEFINED
       display newline "After append:"
       perform show-records
       >>END-IF

       perform verify-append
       goback
       .

      *> ***************************************************************
       initial-fill.
       perform open-output-pass-file

       move "jsmith" to account
       move "x" to password
       move 1001 to uid
       move 1000 to gid
       move "Joe Smith" to fullname
       move "Room 1007" to office
       move "(234)555-8917" to extension
       move "(234)555-0077" to homephone
       move "jsmith@rosettacode.org" to email
       move "/home/jsmith" to homedir
       move "/bin/bash" to shell
       perform write-pass-record

       move "jdoe" to account
       move "x" to password
       move 1002 to uid
       move 1000 to gid
       move "Jane Doe" to fullname
       move "Room 1004" to office
       move "(234)555-8914" to extension
       move "(234)555-0044" to homephone
       move "jdoe@rosettacode.org" to email
       move "/home/jdoe" to homedir
       move "/bin/bash" to shell
       perform write-pass-record

       perform close-pass-file
       .

      *> **********************
       check-pass-file.
       if not ok-status then
           perform file-error
       end-if
       .

      *> **********************
       check-pass-with-eof.
       if not ok-status and not eof-pass then
           perform file-error
       end-if
       .

      *> **********************
       file-error.
       display "error " file-action space pass-filename
               space pass-status upon syserr
       move 1 to return-code
       goback
       .

      *> **********************
       append-record.
       move "xyz" to account
       move "x" to password
       move 1003 to uid
       move 1000 to gid
       move "X Yz" to fullname
       move "Room 1003" to office
       move "(234)555-8913" to extension
       move "(234)555-0033" to homephone
       move "xyz@rosettacode.org" to email
       move "/home/xyz" to homedir
       move "/bin/bash" to shell

       perform open-extend-pass-file
       perform write-pass-record
       perform close-pass-file
       .

      *> **********************
       open-output-pass-file.
       open output pass-file with lock
       move "open output" to file-action
       perform check-pass-file
       .

      *> **********************
       open-extend-pass-file.
       open extend pass-file with lock
       move "open extend" to file-action
       perform check-pass-file
       .

      *> **********************
       open-input-pass-file.
       open input pass-file
       move "open input" to file-action
       perform check-pass-file
       .

      *> **********************
       close-pass-file.
       close pass-file
       move "closing" to file-action
       perform check-pass-file
       .

      *> **********************
       write-pass-record.
       set total-length to 1
       set pass-length to :LRECL:
       string
           account delimited by space
           colon
           password delimited by space
           colon
           trim(uid leading) delimited by size
           colon
           trim(gid leading) delimited by size
           colon
           trim(fullname trailing) delimited by size
           comma-mark
           trim(office trailing) delimited by size
           comma-mark
           trim(extension trailing) delimited by size
           comma-mark
           trim(homephone trailing) delimited by size
           comma-mark
           email delimited by space
           colon
           trim(homedir trailing) delimited by size
           colon
           trim(shell trailing) delimited by size
           into fd-pass-record with pointer total-length
           on overflow
               display "error: fd-pass-record truncated at "
                       total-length upon syserr
       end-string
       set pass-length to total-length
       set pass-length down by 1

       write fd-pass-record
       move "writing" to file-action
       perform check-pass-file
       .

      *> **********************
       read-pass-file.
       read pass-file
       move "reading" to file-action
       perform check-pass-with-eof
       .

      *> **********************
       show-records.
       perform open-input-pass-file

       perform read-pass-file
       perform until eof-pass
           perform show-pass-record
           perform read-pass-file
       end-perform

       perform close-pass-file
       .

      *> **********************
       show-pass-record.
       display fd-pass-record
       .

      *> **********************
       verify-append.
       perform open-input-pass-file

       move 0 to tally
       perform read-pass-file
       perform until eof-pass
           add 1 to tally
           unstring fd-pass-record delimited by colon
               into account
           if key-account then exit perform end-if
           perform read-pass-file
       end-perform
       if (key-account and tally not > 2) or (not key-account) then
           display
               "error: appended record not found in correct position"
              upon syserr
       else
           display "Appended record: " with no advancing
           perform show-pass-record
       end-if

       perform close-pass-file
       .

       end program append.
