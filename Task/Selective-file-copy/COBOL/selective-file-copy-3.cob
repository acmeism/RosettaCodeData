      *> Tectonics:
      *>   cobc -xj selective-copy.cob
      *>   cobc -xjd -DSHOWING selective-copy.cob
      *> ***************************************************************
       identification division.
       program-id. selective-copy.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select input-file
           assign to input-filename
           organization is sequential
           status is input-status.

           select output-file
           assign to output-filename
           organization is sequential
           status is output-status.

      *> emulate a COPY book, with an inline REPLACE

       REPLACE ==:INPUT-RECORD:== BY
       ==
          05 field-a    pic x(5).
          05 field-b    pic x(5).
          05 field-c    pic s9(4) sign is trailing separate.
          05 field-d    pic x(5).
       ==

       ==:OUTPUT-RECORD:== BY
       ==
          05 field-a    pic x(5).
          05 field-c    pic ----9.
          05 field-x    pic x(5).
       ==.

       data division.
       file section.
       fd input-file.
       01 fd-input-record.
       :INPUT-RECORD:

       fd output-file.
       01 fd-output-record.
       :OUTPUT-RECORD:

       working-storage section.
       01 input-filename.
          05 filler            value "selective-input-file".
       01 input-status         pic xx.
          88 ok-input          values '00' thru '09'.
          88 eof-input         value '10'.
       01 ws-input-record.
       :INPUT-RECORD:

       01 output-filename.
          05 filler            value "selective-output-file".
       01 output-status        pic xx.
          88 ok-output         values '00' thru '09'.
          88 eof-output        value '10'.
       01 ws-output-record.
       :OUTPUT-RECORD:

       77 file-action          pic x(11).

       77 math pic s9(5).

      *> ***************************************************************
       procedure division.
       main-routine.
       perform open-files

       perform read-input-file
       perform until eof-input
       >>IF SHOWING IS DEFINED
           display "input  :" ws-input-record ":"
       >>END-IF
           move corresponding ws-input-record to ws-output-record
           move "XXXXX" to field-x in ws-output-record
           perform write-output-record
           perform read-input-file
       end-perform

       perform close-files
       goback.

      *> ***************************************************************
       open-files.
       open input input-file
       move "open input" to file-action
       perform check-input-file

       open output output-file
       move "open output" to file-action
       perform check-output-file
       .

      *> **********************
       read-input-file.
       read input-file into ws-input-record
       move "reading" to file-action
       perform check-input-with-eof
       .

      *> **********************
       write-output-record.
       write fd-output-record from ws-output-record
       move "writing" to file-action
       perform check-output-file
       >>IF SHOWING IS DEFINED
           display "output :" ws-output-record ":"
       >>END-IF
       .

      *> **********************
       close-files.
       close input-file output-file
       perform check-input-with-eof
       perform check-output-file
       .

      *> **********************
       check-input-file.
       if not ok-input then
           perform input-file-error
       end-if
       .

      *> **********************
       check-input-with-eof.
       if not ok-input and not eof-input then
           perform input-file-error
       end-if
       .

      *> **********************
       input-file-error.
       display "error " file-action space input-filename
               space input-status upon syserr
       move 1 to return-code
       goback
       .

      *> **********************
       check-output-file.
       if not ok-output then
           display "error " file-action space output-filename
                   space output-status upon syserr
           move 1 to return-code
           goback
       end-if
       .

       end program selective-copy.
