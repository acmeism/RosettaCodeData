/* Simple ARexx program to open a port after checking if it's already open */
IF Show('PORTS','ROSETTA') THEN DO           /* Port is already open; exit */
   SAY 'This program may only be run in a single instance at a time.'
   EXIT 5                                    /* Exit with a mild warning   */
   END
                 /* Open rexxsupport.library so that ports can be opened   */
IF ~Show('LIBRARIES','rexxsupport.library')
   THEN CALL AddLib('rexxsupport.library',0,-30,0)

IF ~OpenPort('ROSETTA')    THEN EXIT 10       /* Open port, end if it fails */

SAY 'Program is now running.'

DO FOREVER                                    /* Busyloop                   */
   /* Program stuff here */
   END

EXIT 0
