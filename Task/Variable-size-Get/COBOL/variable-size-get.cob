       identification division.
       program-id. variable-size-get.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 bc-len           constant as length of binary-char.
       01 fd-34-len        constant as length of float-decimal-34.

       77 fixed-character  pic x(13).
       77 fixed-national   pic n(13).
       77 fixed-nine       pic s9(5).
       77 fixed-separate   pic s9(5) sign trailing separate.
       77 computable-field pic s9(5) usage computational-5.
       77 formatted-field  pic +z(4),9.

       77 binary-field     usage binary-double.
       01 pointer-item     usage pointer.

       01 group-item.
          05 first-inner   pic x occurs 0 to 3 times depending on odo.
          05 second-inner  pic x occurs 0 to 5 times depending on odo-2.
       01 odo              usage index value 2.
       01 odo-2            usage index value 4.

       procedure division.
       sample-main.
       display "Size of:"
       display "BINARY-CHAR             : " bc-len
       display "  bc-len constant       : " byte-length(bc-len)
       display "FLOAT-DECIMAL-34        : " fd-34-len
       display "  fd-34-len constant    : " byte-length(fd-34-len)

       display "PIC X(13) field         : " length of fixed-character
       display "PIC N(13) field         : " length of fixed-national

       display "PIC S9(5) field         : " length of fixed-nine
       display "PIC S9(5) sign separate : " length of fixed-separate
       display "PIC S9(5) COMP-5        : " length of computable-field

       display "ALPHANUMERIC-EDITED     : " length(formatted-field)

       display "BINARY-DOUBLE field     : " byte-length(binary-field)
       display "POINTER field           : " length(pointer-item)
       >>IF P64 IS SET
       display "  sizeof(char *) > 4"
       >>ELSE
       display "  sizeof(char *) = 4"
       >>END-IF

       display "Complex ODO at 2 and 4  : " length of group-item
       set odo down by 1.
       set odo-2 up by 1.
       display "Complex ODO at 1 and 5  : " length(group-item)

       goback.
       end program variable-size-get.
