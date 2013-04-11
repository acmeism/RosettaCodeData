      PROGRAM INFINITELOOP
C       While you can put this label on the WRITE statement, it is good
C       form to label CONTINUE statements whenever possible, rather than
C       statements that actually contain instructions. This way, you can
C       indent inside the "loop" and make it more readable.
   10   CONTINUE
          WRITE (*,*) 'SPAM'
          GOTO 10

C       It is also good form to close the "loop" with another label. In
C       this case, there is absolutely no reason to do this at all, but,
C       if you wanted to break, you would be able to add `GOTO 20` to
C       exit the loop.
   20   CONTINUE

        STOP
      END
