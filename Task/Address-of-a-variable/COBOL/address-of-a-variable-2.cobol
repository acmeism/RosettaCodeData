OCOBOL*> Rosetta Code set address example
      *> tectonics: cobc -x setaddr.cob && ./setaddr
       program-id. setaddr.
       data division.
       working-storage section.
       01 prealloc  pic x(8) value 'somedata'.
       01 var       pic x(8) based.
       procedure division.
       set address of var to address of prealloc
       display var end-display
       goback.
       end program setaddr.
