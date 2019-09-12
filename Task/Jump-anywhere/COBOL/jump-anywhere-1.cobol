IDENTIFICATION DIVISION.
PROGRAM-ID. JUMPS-PROGRAM.
* Nobody writes like this, of course; but...
PROCEDURE DIVISION.
* You can jump anywhere you like.
START-PARAGRAPH.
    GO TO AN-ARBITRARY-PARAGRAPH.
YET-ANOTHER-PARAGRAPH.
    ALTER START-PARAGRAPH TO PROCEED TO A-PARAGRAPH-SOMEWHERE.
* That's right, folks: we don't just have GO TOs, we have GO TOs whose
* destinations can be changed at will, from anywhere in the program,
* at run time.
    GO TO START-PARAGRAPH.
* But bear in mind: once you get there, the GO TO no longer goes to
* where it says it goes to.
A-PARAGRAPH-SOMEWHERE.
    DISPLAY 'Never heard of him.'
    STOP RUN.
SOME-OTHER-PARAGRAPH.
* You think that's bad? You ain't seen nothing.
    GO TO YET-ANOTHER-PARAGRAPH.
AN-ARBITRARY-PARAGRAPH.
    DISPLAY 'Edsger who now?'
    GO TO SOME-OTHER-PARAGRAPH.
