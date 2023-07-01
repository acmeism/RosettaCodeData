INTEGER, PARAMETER ::  i8 = SELECTED_INT_KIND(2)
INTEGER, PARAMETER :: i16 = SELECTED_INT_KIND(4)
INTEGER, PARAMETER :: i32 = SELECTED_INT_KIND(8)
INTEGER, PARAMETER :: i64 = SELECTED_INT_KIND(16)
INTEGER(i8)  :: onebyte = 0
INTEGER(i16) :: twobytes = 0
INTEGER(i32) :: fourbytes = 0
INTEGER(i64) :: eightbytes = 0

WRITE (*,*) BIT_SIZE(onebyte), DIGITS(onebyte)             ! prints 8 and 7
WRITE (*,*) BIT_SIZE(twobytes), DIGITS(twobytes)           ! prints 16 and 15
WRITE (*,*) BIT_SIZE(fourbytes),  DIGITS(fourbytes)        ! prints 32 and 31
WRITE (*,*) BIT_SIZE(eightbytes),  DIGITS(eightbytes)      ! prints 64 and 63
WRITE (*,*) DIGITS(0.0), DIGITS(0d0)                       ! prints 24 and 53
