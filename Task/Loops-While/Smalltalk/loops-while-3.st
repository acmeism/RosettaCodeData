number := 1024.
[ number <= 0 ] whileFalse:
  [ Transcript print: number; nl.
  number := number // 2 ]
