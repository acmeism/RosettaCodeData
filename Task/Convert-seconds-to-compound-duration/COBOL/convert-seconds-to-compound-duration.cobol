       identification division.
       program-id. fmt-dura.
       data division.
       working-storage section.
       1 input-seconds pic 9(8).
       1 formatted-duration pic x(30) global.
       1 fractions.
        2 weeks pic z(3)9.
        2 days pic z(3)9.
        2 hours pic z(3)9.
        2 minutes pic z(3)9.
        2 seconds pic z(3)9.
       1 .
        2 weeks-str pic x(4) value "wk".
        2 days-str pic x(4) value "d".
        2 hours-str pic x(4) value "hr".
        2 minutes-str pic x(4) value "min".
        2 seconds-str pic x(4) value "sec".
       1 work binary global.
        2 str-pos pic 9(4).
        2 chars-transferred pic 9(4).
       procedure division.
       begin.
           display "Enter duration (seconds): " no advancing
           accept input-seconds
           divide input-seconds by 60 giving input-seconds
               remainder seconds
           divide input-seconds by 60 giving input-seconds
               remainder minutes
           divide input-seconds by 24 giving input-seconds
               remainder hours
           divide input-seconds by 7 giving weeks
               remainder days
           move 1 to str-pos
           call "fmt" using weeks weeks-str
           call "fmt" using days days-str
           call "fmt" using hours hours-str
           call "fmt" using minutes minutes-str
           call "fmt" using seconds seconds-str
           display formatted-duration
           stop run
           .

       identification division.
       program-id. fmt.
       data division.
       working-storage section.
       77 nothing pic x.
       linkage section.
       1 formatted-value pic x(4).
       1 duration-size pic x(4).
       procedure division using formatted-value duration-size.
       begin.
           if function numval (formatted-value) not = 0
               perform insert-comma-space
               unstring formatted-value delimited all space
                   into nothing formatted-duration (str-pos:)
                   count chars-transferred
               add chars-transferred to str-pos
               string space delimited size
                   duration-size delimited space
                   into formatted-duration pointer str-pos
           end-if
           exit program
           .

       insert-comma-space.
           if str-pos > 1
               move ", " to formatted-duration (str-pos:)
               add 2 to str-pos
           end-if
           .
       end program fmt.
       end program fmt-dura.
