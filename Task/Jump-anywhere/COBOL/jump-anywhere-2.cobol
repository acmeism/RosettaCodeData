 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 province PICTURE IS 99 VALUE IS 2.

 PROCEDURE DIVISION.
     GO TO quebec, ontario, manitoba DEPENDING ON province.
*    Jumps to section or paragraph named 'ontario'.
