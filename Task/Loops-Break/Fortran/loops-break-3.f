      SUBROUTINE RANDU(IX,IY,YFL)
Copied from the IBM1130 Scientific Subroutines Package (1130-CM-02X): Programmer's Manual, page 60.
CAUTION! This routine's 32-bit variant is reviled by Prof. Knuth and many others for good reason!
        IY = IX*899
        IF (IY) 5,6,6
    5   IY = IY + 32767 + 1
    6   YFL = IY
        YFL = YFL/32767.
      END

      FUNCTION IR19(IX)
        CALL RANDU(IX,IY,YFL)
        IX = IY
        I = YFL*20
        IF (I - 20) 12,11,11
   11   I = 19
   12   IR19 = I
      END

      IX = 1
Commence the loop.
   10 I = IR19(IX)
      WRITE (6,11) I
   11 FORMAT (I3)
      IF (I - 10) 12,20,12
   12 I = IR19(IX)
      WRITE (6,11) I
      GO TO 10
Cease.
   20 CONTINUE
      END
