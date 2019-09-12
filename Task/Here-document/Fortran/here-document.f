      INTEGER I         !A stepper.
      CHARACTER*666 I AM    !Sufficient space.
      I AM =                                                           "<col72
C              111111111122222222223333333333444444444455555555556666666666
C     123456789012345678901234567890123456789012345678901234567890123456789
     1                                                                  <col72
     2              I AM                                                <col72
     3                                                                  <col72
     4           THAT I AM                                              <col72
     5"

Chug through the text blob.
      DO I = 0,600,66   !Known length.
        WRITE (6,1) I AM(I + 1:I + 66)  !Reveal one line.
    1   FORMAT (A66)            !No control characters are expected.
      END DO                !On to the next line.
      END
