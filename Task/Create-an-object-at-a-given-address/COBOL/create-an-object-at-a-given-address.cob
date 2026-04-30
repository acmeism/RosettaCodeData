IDENTIFICATION DIVISION.
PROGRAM-ID. object-address-test.
DATA DIVISION.
LOCAL-STORAGE SECTION.
77  int-space PICTURE IS 9(5) VALUE IS 12345.
77  addr      PICTURE IS 9(5) BASED VALUE IS ZERO.
77  point       USAGE IS POINTER.
PROCEDURE DIVISION.
    DISPLAY "Value of integer object   : " int-space
    SET point TO ADDRESS OF int-space
    DISPLAY "Machine address of object : " point
    SET ADDRESS OF addr TO point
    DISPLAY "Value of referent object  : " addr
    MOVE 65535 TO int-space
    DISPLAY "New value of original     : " addr
    DISPLAY "New value of reference    : " int-space
    GOBACK.
END PROGRAM object-address-test.
