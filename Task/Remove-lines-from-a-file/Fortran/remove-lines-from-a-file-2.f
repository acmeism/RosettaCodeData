       CHARACTER*42 FUNCTION ERRORWORDS(IT)	!Look for an explanation. One day, the system may offer coherent messages.
Curious collection of encountered codes. Will they differ on other systems?
Compaq's compiler was taken over by unintel; http://software.intel.com/sites/products/documentation/hpc/compilerpro/en-us/fortran/lin/compiler_f/bldaps_for/common/bldaps_rterrs.htm
contains a schedule of error numbers that matched those I'd found for Compaq, and so some assumptions are added.
Copying all (hundreds!) is excessive; these seem possible for the usage so far made of error diversion.
Compaq's compiler interface ("visual" blah) has a help offering, which can provide error code information.
Compaq messages also appear in http://cens.ioc.ee/local/man/CompaqCompilers/cf/dfuum028.htm#tab_runtime_errors
Combines IOSTAT codes (file open, read etc) with STAT codes (allocate/deallocate) as their numbers are distinct.
Completeness and context remains a problem. Excess brevity means cause and effect can be confused.
        INTEGER IT			!The error code in question.
        INTEGER LASTKNOWN 		!Some codes I know about.
        PARAMETER (LASTKNOWN = 26)	!But only a few, discovered by experiment and mishap.
        TYPE HINT			!For them, I can supply a table.
         INTEGER	CODE		!The code number. (But, different systems..??)
         CHARACTER*42	EXPLICATION	!An explanation. Will it be te answer?
        END TYPE HINT			!Simple enough.
        TYPE(HINT) ERROR(LASTKNOWN)	!So, let's have a collection.
        PARAMETER (ERROR = (/		!With these values.
     1   HINT(-1,"End-of-file at the start of reading!"),	!From examples supplied with the Compaq compiler involving IOSTAT.
     2   HINT( 0,"No worries."),			!Apparently the only standard value.
     3   HINT( 9,"Permissions - read only?"),
     4   HINT(10,"File already exists!"),
     5   HINT(17,"Syntax error in NameList input."),
     6   HINT(18,"Too many values for the recipient."),
     7   HINT(19,"Invalid naming of a variable."),
     8   HINT(24,"Surprise end-of-file during read!"),	!From example source.
     9   HINT(25,"Invalid record number!"),
     o   HINT(29,"File name not found."),
     1   HINT(30,"Unavailable - exclusive use?"),
     2   HINT(32,"Invalid fileunit number!"),
     3   HINT(35,"'Binary' form usage is rejected."),	!From example source.
     4   HINT(36,"Record number for a non-existing record!"),
     5   HINT(37,"No record length has been specified."),
     6   HINT(38,"I/O error during a write!"),
     7   HINT(39,"I/O error during a read!"),
     8   HINT(41,"Insufficient memory available!"),
     9   HINT(43,"Malformed file name."),
     o   HINT(47,"Attempting a write, but read-only is set."),
     1   HINT(66,"Output overflows single record size."),	!This one from experience.
     2   HINT(67,"Input demand exceeds single record size."),	!These two are for unformatted I/O.
     3   HINT(151,"Can't allocate: already allocated!"),	!These different numbers are for memory allocation failures.
     4   HINT(153,"Can't deallocate: not allocated!"),
     5   HINT(173,"The fingered item was not allocated!"),	!Such as an ordinary array that was not allocated.
     6   HINT(179,"Size exceeds addressable memory!")/))
        INTEGER I		!A stepper.
         DO I = LASTKNOWN,1,-1	!So, step through the known codes.
           IF (IT .EQ. ERROR(I).CODE) GO TO 1	!This one?
         END DO			!On to the next.
    1    IF (I.LE.0) THEN	!Fail with I = 0.
           ERRORWORDS = I8FMT(IT)//" is a novel code!"	!Reveal the mysterious number.
          ELSE			!But otherwise, it is found.
           ERRORWORDS = ERROR(I).EXPLICATION	!And these words might even apply.
         END IF			!But on all systems?
       END FUNCTION ERRORWORDS	!Hopefully, helpful.
