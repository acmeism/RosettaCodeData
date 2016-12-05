      INTERFACE
	INTEGER*4 FUNCTION GETFILEINFOQQ(FILES, BUFFER,dwHANDLE)
!DEC$ ATTRIBUTES DEFAULT :: GETFILEINFOQQ
	  CHARACTER*(*) FILES
	  STRUCTURE / FILE$INFO /
	    INTEGER*4       CREATION          ! Creation time (-1 on FAT)
	    INTEGER*4       LASTWRITE         ! Last write to file
	    INTEGER*4       LASTACCESS        ! Last access (-1 on FAT)
	    INTEGER*4       LENGTH            ! Length of file
	    INTEGER*2       PERMIT            ! File access mode
	    CHARACTER*255   NAME              ! File name
	  END STRUCTURE
	  RECORD / FILE$INFO / BUFFER
	  INTEGER*4 dwHANDLE
	END FUNCTION
      END INTERFACE
