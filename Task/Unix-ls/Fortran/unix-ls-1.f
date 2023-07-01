      PROGRAM LS		!Names the files in the current directory.
      USE DFLIB			!Mysterious library.
      TYPE(FILE$INFO) INFO	!With mysterious content.
      NAMELIST /HIC/INFO	!This enables annotated output.
      INTEGER MARK,L		!Assistants.

      MARK = FILE$FIRST		!Starting state.
Call for the next file.
   10 L = GETFILEINFOQQ("*",INFO,MARK)	!Mystery routine returns the length of the file name.
      IF (MARK.EQ.FILE$ERROR) THEN	!Or possibly, not.
        WRITE (6,*) "Error!",L		!Something went wrong.
        WRITE (6,HIC)			!Reveal INFO, annotated.
        STOP "That wasn't nice."	!Quite.
      ELSE IF (IAND(INFO.PERMIT,FILE$DIR) .EQ. 0) THEN	!Not a directory.
        IF (L.GT.0) WRITE (6,*) INFO.NAME(1:L)	!The object of the exercise!
      END IF				!So much for that entry.
      IF (MARK.NE.FILE$LAST) GO TO 10	!Lastness is discovered after the last file is fingered.
      END	!If FILE$LAST is not reached, "system resources may be lost."
