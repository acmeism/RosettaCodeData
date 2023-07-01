!
! lzw_shared_parameters.f90
!
! LZW Common Variables Used by Coder and Decoder
!
! Author: Pedro Garcia Freitas <sawp@sawp.com.br>
! May, 2011
!
! License: Creative Commons http://creativecommons.org/licenses/by-nc-nd/3.0/
!
      MODULE LZW_SHARED_PARAMETERS
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  COMPILER_INTEGER_SIZE = 32 , BITS = 12 , FILEIN = 66 ,     &
                             & FILEOUT = 99 , MAX_VALUE = (2**BITS) - 1 ,                 &
                             & MAX_CODE = MAX_VALUE - 1 , MAX_DICTIONARY_SIZE = 5021 ,    &
                             & SYMBOL_SIZE = 8 , MISSING_BITS = COMPILER_INTEGER_SIZE -   &
                             & SYMBOL_SIZE
!
! Local variables
!
      INTEGER , DIMENSION(0:MAX_DICTIONARY_SIZE)  ::  concatenatedsymbols
      INTEGER , DIMENSION(0:MAX_DICTIONARY_SIZE)  ::  prefixcodes
      INTEGER  ::  the_status = 0

! change this if compiler dont use 32 bits for integer

      END MODULE LZW_SHARED_PARAMETERS
!
! codecIO.f90
!
! bit IO routines for coder and encoder.
!
! Author: Pedro Garcia Freitas <sawp@sawp.com.br>
! May, 2011
!
! License: Creative Commons http://creativecommons.org/licenses/by-nc-nd/3.0/
!
      MODULE CODECIO
      USE LZW_SHARED_PARAMETERS
      IMPLICIT NONE
!
      CONTAINS
      SUBROUTINE SETOUTPUTCODE(Code)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  Code
      INTENT (IN) Code
!
! Local variables
!
      INTEGER  ::  buffer
      INTEGER  ::  outputbitbuffer = 0
      INTEGER  ::  outputbitcount = 0
      INTEGER  ::  shift
      INTEGER  ::  shiftedsymbol
!
      shift = COMPILER_INTEGER_SIZE - BITS - outputbitcount
      shiftedsymbol = ISHFT(Code , shift)
      outputbitbuffer = IOR(outputbitbuffer , shiftedsymbol)
      outputbitcount = outputbitcount + BITS

      DO WHILE(outputbitcount >= SYMBOL_SIZE)
!         IF( outputbitcount<SYMBOL_SIZE )EXIT
         buffer = ISHFT(outputbitbuffer , -MISSING_BITS)
         CALL SETRAWBYTE(buffer)
         outputbitbuffer = ISHFT(outputbitbuffer , SYMBOL_SIZE)
         outputbitcount = outputbitcount - SYMBOL_SIZE
      END DO
      RETURN
      END SUBROUTINE SETOUTPUTCODE


      SUBROUTINE SETRAWBYTE(Symbol)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  Symbol
      INTENT (IN) Symbol
!

      CALL FPUTC(FILEOUT , ACHAR(Symbol))
      END SUBROUTINE SETRAWBYTE


      FUNCTION GETRAWBYTE()
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  GETRAWBYTE
!
! Local variables
!
      CHARACTER  ::  bufferedbyte
!
      CALL FGETC(FILEIN , bufferedbyte , THE_status)
      GETRAWBYTE = IACHAR(bufferedbyte)
      END FUNCTION GETRAWBYTE

      FUNCTION GETINPUTCODE()
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  GETINPUTCODE
!
! Local variables
!
      INTEGER  ::  inputbitbuffer = 0
      INTEGER  ::  inputbitcounter = 0
      INTEGER  ::  integerinputbuff
      INTEGER  ::  returnn
      INTEGER  ::  shiftedbit
!
      DO WHILE( inputbitcounter <= MISSING_BITS )
!         IF( inputbitcounter>MISSING_BITS )EXIT
         integerinputbuff = GETRAWBYTE()
         shiftedbit = ISHFT(integerinputbuff , MISSING_BITS - inputbitcounter)
         inputbitbuffer = IOR(inputbitbuffer , shiftedbit)
         inputbitcounter = inputbitcounter + SYMBOL_SIZE
      END DO

      returnn = ISHFT(inputbitbuffer , BITS - COMPILER_INTEGER_SIZE)
      inputbitbuffer = ISHFT(inputbitbuffer , BITS)
      inputbitcounter = inputbitcounter - BITS
      GETINPUTCODE = returnn
      RETURN
      END FUNCTION GETINPUTCODE
end module codecIO
! lzw_encoder.f90
!
! LZW Coder (Compressor)
!
! Author: Pedro Garcia Freitas <sawp@sawp.com.br>
! May, 2011
!
! License: Creative Commons http://creativecommons.org/licenses/by-nc-nd/3.0/
!
      MODULE LZW_ENCODER
      USE LZW_SHARED_PARAMETERS
      USE CODECIO
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  HASH_SHIFT = BITS - SYMBOL_SIZE
!
! Local variables
!
      INTEGER , DIMENSION(0:MAX_DICTIONARY_SIZE)  ::  symbolvalues
      CONTAINS
      SUBROUTINE COMPRESS()
      IMPLICIT NONE
!
! Local variables
!
      INTEGER  ::  codedsymbol
      INTEGER  ::  my_index
      INTEGER  ::  nextsymbol
      INTEGER  ::  symbol
      CHARACTER  ::  bufferedbyte
!
      nextsymbol = COMPILER_INTEGER_SIZE*SYMBOL_SIZE
      SYMbolvalues(:) = -1

!      codedsymbol = GETRAWBYTE()
      CALL FGETC(FILEIN , bufferedbyte , THE_status)
      codedsymbol = IACHAR(bufferedbyte)
!Can be hand optimized - optimization
      DO WHILE(THE_status == 0)
!         symbol = GETRAWBYTE()     ! Manual inline of function
          CALL FGETC(FILEIN , bufferedbyte , THE_status)
          symbol = IACHAR(bufferedbyte)
         IF( THE_status/=0 )CYCLE

         my_index = GETPOSITIONONDICTIONARY(codedsymbol , symbol)
         IF( SYMbolvalues(my_index)/= - 1 )THEN
            codedsymbol = SYMbolvalues(my_index)
         ELSE
            IF( nextsymbol<=MAX_CODE )THEN
               SYMbolvalues(my_index) = nextsymbol
               nextsymbol = nextsymbol + 1
               PREfixcodes(my_index) = codedsymbol
               CONcatenatedsymbols(my_index) = symbol
            END IF
            CALL SETOUTPUTCODE(codedsymbol)
            codedsymbol = symbol
         END IF
      END DO
      CALL SETOUTPUTCODE(codedsymbol)
      CALL SETOUTPUTCODE(MAX_VALUE)
      CALL SETOUTPUTCODE(0)
      END SUBROUTINE COMPRESS

function getPositionOnDictionary(hashPrefix, hashSymbol)
      integer, intent(in) :: hashPrefix
      integer, intent(in) :: hashSymbol
      integer             :: getPositionOnDictionary
      integer             :: index
      integer             :: offset

      index = ishft(hashSymbol, HASH_SHIFT)
      index = ieor(index, hashPrefix)
      if (index == 0) then
        offset = 1
      else
        offset = MAX_DICTIONARY_SIZE - index
      endif

      do
        if (symbolValues(index) == -1) then
          getPositionOnDictionary = index
          exit
        endif

        if (prefixCodes(index) == hashPrefix .and. &
            & concatenatedSymbols(index) == hashSymbol) then
          getPositionOnDictionary = index
          exit
        endif

        index = index - offset
        if (index < 0) then
          index = index + MAX_DICTIONARY_SIZE
        endif
      end do
      return
    end function

end module LZW_Encoder
! lzw_decoder.f90
!
! LZW Decoder (Expanssor)
!
! Author: Pedro Garcia Freitas <sawp@sawp.com.br>
! May, 2011
!
! License: Creative Commons http://creativecommons.org/licenses/by-nc-nd/3.0/
!
      MODULE LZW_DECODER
      USE LZW_SHARED_PARAMETERS
      USE CODECIO
      IMPLICIT NONE
!
! Derived Type definitions
!
      TYPE :: DECODE_BUFFER_STACK
         INTEGER , DIMENSION(0:MAX_DICTIONARY_SIZE)  ::  DECODERSTACK
         INTEGER  ::  TOP
      END TYPE DECODE_BUFFER_STACK
!
! Local variables
!
      TYPE(DECODE_BUFFER_STACK)  ::  stack
      CONTAINS
!
!       Can be hand optimized - optimization
      SUBROUTINE DECOMPRESS()
      IMPLICIT NONE
!
! Local variables
!
      INTEGER  ::  newsymbol
      INTEGER  ::  nextsymbol
      INTEGER  ::  oldsymbol
      INTEGER  ::  popedsymbol
      INTEGER  ::  symbol
!
      nextsymbol = COMPILER_INTEGER_SIZE*SYMBOL_SIZE
      oldsymbol = GETINPUTCODE()
      symbol = oldsymbol

      CALL SETRAWBYTE(oldsymbol)

      DO
         newsymbol = GETINPUTCODE()

         IF( newsymbol==MAX_VALUE )RETURN

         IF( newsymbol>=nextsymbol )THEN
            STAck%DECODERSTACK(0) = symbol
            CALL DECODESYMBOL(STAck%DECODERSTACK(1:) , oldsymbol)
         ELSE
            CALL DECODESYMBOL(STAck%DECODERSTACK(:) , newsymbol)
         END IF

         symbol = STAck%DECODERSTACK(STAck%TOP)

         DO WHILE ( STAck%TOP>=0 )
            popedsymbol = STAck%DECODERSTACK(STAck%TOP)
            CALL SETRAWBYTE(popedsymbol)
            STAck%TOP = STAck%TOP - 1
         END DO

         IF( nextsymbol<=MAX_CODE )THEN
            PREfixcodes(nextsymbol) = oldsymbol
            CONcatenatedsymbols(nextsymbol) = symbol
            nextsymbol = nextsymbol + 1
         END IF
         oldsymbol = newsymbol
      END DO
      RETURN
      END SUBROUTINE DECOMPRESS

      SUBROUTINE DECODESYMBOL(Buffer , Code)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  Code
      INTEGER , DIMENSION(:)  ::  Buffer
      INTENT (IN) Code
      INTENT (INOUT) Buffer
!
! Local variables
!
      INTEGER  ::  i
      INTEGER  ::  j
      INTEGER  ::  symbol
!
      j = 0
      symbol = Code
      STAck%TOP = 0
      DO WHILE ( symbol>=COMPILER_INTEGER_SIZE*SYMBOL_SIZE )
 !        IF( symbol<COMPILER_INTEGER_SIZE*SYMBOL_SIZE )EXIT

         IF( j>=MAX_CODE )THEN
            PRINT * , "Decoding error"
            STOP
         END IF

         i = STAck%TOP + 1
         Buffer(i) = CONcatenatedsymbols(symbol)
         symbol = PREfixcodes(symbol)
         STAck%TOP = STAck%TOP + 1
         j = j + 1
      END DO
      i = j + 1
      Buffer(i) = symbol
      END SUBROUTINE DECODESYMBOL
end module LZW_Decoder
! lzw.f90
!
! LZW Coder and Decoder
!
! Author: Pedro Garcia Freitas <sawp@sawp.com.br>
! May, 2011
!
! License: Creative Commons http://creativecommons.org/licenses/by-nc-nd/3.0/
!

      MODULE LZW
      USE LZW_SHARED_PARAMETERS
      USE LZW_ENCODER
      USE LZW_DECODER
      IMPLICIT NONE
      CONTAINS
      SUBROUTINE INIT(Input , Output , Operation , Filename)
      IMPLICIT NONE
!
! Dummy arguments
!
      CHARACTER(100)  ::  Filename
      CHARACTER(100)  ::  Input
      CHARACTER(1)  ::  Operation
      CHARACTER(100)  ::  Output
      INTENT (IN) Filename , Input , Operation , Output
!
      IF( Operation/='d' .AND. Operation/='e' )THEN
         PRINT * , "Usage: " // TRIM(Filename) // " <operation> input output"
         PRINT * , "Possible operations: "
         PRINT * , "    e -> encode (compress)"
         PRINT * , "    d -> decode (inflate)"
         STOP
      END IF

      OPEN(UNIT = FILEIN , FILE = Input , ACTION = "read" , STATUS = "old" ,              &
          &ACCESS = 'stream' , FORM = "formatted")
      OPEN(UNIT = FILEOUT , FILE = Output , ACTION = "write" , STATUS = "replace" ,       &
         & ACCESS = 'stream' , FORM = "formatted")

      IF( Operation=='d' )THEN
         PRINT * , "Decoding..."
         CALL DECOMPRESS()
      ELSE
         PRINT * , "Encoding..."
         CALL COMPRESS()
      END IF

      CLOSE(UNIT = FILEIN)
      CLOSE(UNIT = FILEOUT)
      END SUBROUTINE INIT
end module LZW
!
      PROGRAM MAIN
      USE LZW
      IMPLICIT NONE
!
! Local variables
!
      CHARACTER(100)  ::  filename
      REAL  ::  finish
      CHARACTER(100)  ::  input
      CHARACTER(1)  ::  operation
      CHARACTER(100)  ::  output
      REAL  ::  start
!
      CALL GETARG(0 , filename)
      CALL GETARG(1 , operation)
      CALL GETARG(2 , input)
      CALL GETARG(3 , output)
      CALL CPU_TIME(start)
      CALL INIT(input , output , operation , filename)
      CALL CPU_TIME(finish)
      PRINT '("Time = ",f6.3," seconds.")' , finish - start
      END PROGRAM MAIN
