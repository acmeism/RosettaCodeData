      ...
      ASSIGN 1101 to WHENCE   !Remember my return point.
      GO TO 1000              !Dive into a "subroutine"
 1101 CONTINUE                !Resume.
      ...
      ASSIGN 1102 to WHENCE   !Prepare for another invocation.
      GO TO 1000              !Like GOSUB in BASIC.
 1102 CONTINUE                !Carry on.
      ...
Common code, far away.
 1000 do something            !This has all the context available.
      GO TO WHENCE            !Return whence I came.
