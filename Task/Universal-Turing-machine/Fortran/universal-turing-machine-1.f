  200 I = STATE*NSYMBOL - ICHAR(TAPE(HEAD))	!Index the transition.
      TAPE(HEAD) = MARK(I)			!Do it. Possibly not changing the symbol.
      HEAD = HEAD + MOVE(I)			!Possibly not moving the head.
      STATE = ICHAR(NEXT(I))			!Hopefully, something has changed!
      IF (STATE.GT.0) GO TO 200			!Otherwise, we might loop forever...
