$ i = 1024
$Loop:
$ IF ( i .LE. 0 ) THEN GOTO LoopEnd
$ WRITE sys$output F$FAO( "  i = !4UL", i )  ! formatted ASCII output, fixed-width field
$ ! Output alternatives:
$ !   WRITE sys$output F$STRING( i )         ! explicit integer-to-string conversion
$ !   WRITE sys$output i                     ! implicit conversion to string/output
$ i = i / 2
$ GOTO Loop
$LoopEnd:
