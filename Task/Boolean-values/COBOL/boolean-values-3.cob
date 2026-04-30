       PROGRAM-ID. Condition-Example.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Foo PIC 9 VALUE 5.
           88  Is-Not-Zero VALUE 1 THRU 9
               WHEN SET TO FALSE IS 0.

       PROCEDURE DIVISION.
       Main.
           PERFORM Is-Foo-Zero

           SET Is-Not-Zero TO FALSE
           PERFORM Is-Foo-Zero

           SET Is-Not-Zero TO TRUE
           PERFORM Is-Foo-Zero

           GOBACK
           .

       Is-Foo-Zero.
           IF Is-Not-Zero
               DISPLAY "Foo is not zero, it is " Foo "."
           ELSE
               DISPLAY "Foo is zero."
           END-IF
           .
