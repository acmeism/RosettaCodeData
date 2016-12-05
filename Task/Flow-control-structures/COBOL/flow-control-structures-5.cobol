       PROGRAM-ID. Perform-Example.

       PROCEDURE DIVISION.
       Main.
           PERFORM Moo
           PERFORM Display-Stuff
           PERFORM Boo THRU Moo

           GOBACK
           .

       Display-Stuff SECTION.
       Foo.
           DISPLAY "Foo " WITH NO ADVANCING
           .

       Boo.
           DISPLAY "Boo " WITH NO ADVANCING
           .

       Moo.
           DISPLAY "Moo"
           .
