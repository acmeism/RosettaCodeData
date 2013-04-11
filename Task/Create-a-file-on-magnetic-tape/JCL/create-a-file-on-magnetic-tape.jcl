// EXEC PGM=IEBGENER
//* Create a file named "TAPE.FILE" on magnetic tape; "UNIT=TAPE"
//*    may vary depending on site-specific esoteric name assignment
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT2   DD UNIT=TAPE,DSN=TAPE.FILE,DISP=(,CATLG)
//SYSUT1   DD *
DATA TO BE WRITTEN TO TAPE
/*
