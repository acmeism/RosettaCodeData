       identification division.
       program-id. ReadConfiguration.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select config-file     assign to "Configuration.txt"
                                  organization line sequential.
       data division.
       file section.

       fd  config-file.
       01  config-record          pic is x(128).

       working-storage section.
       77  idx                    pic 9(3).
       77  pos                    pic 9(3).
       77  last-pos               pic 9(3).
       77  config-key             pic x(32).
       77  config-value           pic x(64).
       77  multi-value            pic x(64).
       77  full-name              pic x(64).
       77  favourite-fruit        pic x(64).
       77  other-family           pic x(64) occurs 10.
       77  need-speeling          pic x(5) value "false".
       77  seeds-removed          pic x(5) value "false".

       procedure division.
       main.
           open input config-file
           perform until exit
              read config-file
                 at end
                    exit perform
              end-read
              move trim(config-record) to config-record
              if config-record(1:1) = "#" or ";" or spaces
                 exit perform cycle
              end-if
              unstring config-record delimited by spaces into config-key
              move trim(config-record(length(trim(config-key)) + 1:)) to config-value
              if config-value(1:1) = "="
                 move trim(config-value(2:)) to config-value
              end-if
              evaluate upper-case(config-key)
                 when "FULLNAME"
                    move config-value to full-name
                 when "FAVOURITEFRUIT"
                    move config-value to favourite-fruit
                 when "NEEDSPEELING"
                    if config-value = spaces
                       move "true" to config-value
                    end-if
                    if config-value = "true" or "false"
                       move config-value to need-speeling
                    end-if
                 when "SEEDSREMOVED"
                    if config-value = spaces
                       move "true" to config-value
                    end-if,
                    if config-value = "true" or "false"
                       move config-value to seeds-removed
                    end-if
                 when "OTHERFAMILY"
                    move 1 to idx, pos
                    perform until exit
                       unstring config-value delimited by "," into multi-value with pointer pos
                          on overflow
                             move trim(multi-value) to other-family(idx)
                             move pos to last-pos
                          not on overflow
                             if config-value(last-pos:) <> spaces
                                move trim(config-value(last-pos:)) to other-family(idx)
                             end-if,
                             exit perform
                       end-unstring
                       add 1 to idx
                    end-perform
              end-evaluate
           end-perform
           close config-file

           display "fullname = " full-name
           display "favouritefruit = " favourite-fruit
           display "needspeeling = " need-speeling
           display "seedsremoved = " seeds-removed
           perform varying idx from 1 by 1 until idx > 10
              if other-family(idx) <> low-values
                 display "otherfamily(" idx ") = " other-family(idx)
              end-if
           end-perform
           .
