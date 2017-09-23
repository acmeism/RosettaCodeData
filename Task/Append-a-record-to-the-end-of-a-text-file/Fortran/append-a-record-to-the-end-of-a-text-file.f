      PROGRAM DEMO	!As per the described task, more or less.
      TYPE DETAILS		!Define a component.
       CHARACTER*28 FULLNAME
       CHARACTER*12 OFFICE
       CHARACTER*16 EXTENSION
       CHARACTER*16 HOMEPHONE
       CHARACTER*88 EMAIL
      END TYPE DETAILS
      TYPE USERSTUFF		!Define the desired data aggregate.
       CHARACTER*8 ACCOUNT
       CHARACTER*8 PASSWORD	!Plain text!! Eeek!!!
       INTEGER*2 UID
       INTEGER*2 GID
       TYPE(DETAILS) PERSON
       CHARACTER*18 DIRECTORY
       CHARACTER*12 SHELL
      END TYPE USERSTUFF
      TYPE(USERSTUFF) NOTE	!After all that, I'll have one.
      NAMELIST /STUFF/ NOTE	!Enables free-format I/O, with names.
      INTEGER F,MSG,N
      MSG = 6	!Standard output.
      F = 10	!Suitable for some arbitrary file.
      OPEN(MSG, DELIM = "QUOTE")	!Text variables are to be enquoted.

Create the file and supply its initial content.
      OPEN (F, FILE="Staff.txt",STATUS="REPLACE",ACTION="WRITE",
     1 DELIM="QUOTE",RECL=666)	!Special parameters for the free-format WRITE working.

      WRITE (F,*) USERSTUFF("jsmith","x",1001,1000,
     1 DETAILS("Joe Smith","Room 1007","(234)555-8917",
     2  "(234)555-0077","jsmith@rosettacode.org"),
     2 "/home/jsmith","/bin/bash")

      WRITE (F,*) USERSTUFF("jdoe","x",1002,1000,
     1 DETAILS("Jane Doe","Room 1004","(234)555-8914",
     2  "(234)555-0044","jdoe@rosettacode.org"),
     3 "home/jdoe","/bin/bash")
      CLOSE (F)		!The file is now existing.

Choose the existing file, and append a further record to it.
      OPEN (F, FILE="Staff.txt",STATUS="OLD",ACTION="WRITE",
     1 DELIM="QUOTE",RECL=666,ACCESS="APPEND")

      NOTE = USERSTUFF("xyz","x",1003,1000,		!Create a new record's worth of stuff.
     1 DETAILS("X Yz","Room 1003","(234)555-8193",
     2  "(234)555-033","xyz@rosettacode.org"),
     3 "/home/xyz","/bin/bash")
      WRITE (F,*) NOTE					!Append its content to the file.
      CLOSE (F)

Chase through the file, revealing what had been written..
      OPEN (F, FILE="Staff.txt",STATUS="OLD",ACTION="READ",
     1 DELIM="QUOTE",RECL=666)
      N = 0
   10 READ (F,*,END = 20) NOTE	!As it went out, so it comes in.
      N = N + 1			!Another record read.
      WRITE (MSG,11) N		!Announce.
   11 FORMAT (/,"Record ",I0)	!Thus without quotes around the text part.
      WRITE (MSG,STUFF)		!Reveal.
      GO TO 10			!Try again.

Closedown.
   20 CLOSE (F)
      END
