 IDENTIFICATION DIVISION.
 PROGRAM-ID. jumps-program.
* Nobody writes like this, of course; but...

 PROCEDURE DIVISION.

* You can jump anywhere you like.
 start-paragraph.
     GO TO an-arbitrary-paragraph.

 yet-another-paragraph.
     ALTER start-paragraph TO PROCEED TO a-paragraph-somewhere.
* That's right, folks: we don't just have GO TOs, we have GO TOs whose
* destinations can be changed at will, from anywhere in the program,
* at run time.
     GO TO start-paragraph.
* But bear in mind: once you get there, the GO TO no longer goes to
* where it says it goes to.

 a-paragraph-somewhere.
     DISPLAY 'Never heard of him.'
     STOP RUN.

 some-other-paragraph.
* You think that's bad? You ain't seen nothing.
     GO TO yet-another-paragraph.

 an-arbitrary-paragraph.
     DISPLAY 'Edsger who now?'
     GO TO some-other-paragraph.

 END PROGRAM jumps-program.
