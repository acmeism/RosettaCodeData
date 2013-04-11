number := 1024.
[ number > 0 ] whileTrue:
  [ Transcript print: number; nl.
  number := number // 2 ]
