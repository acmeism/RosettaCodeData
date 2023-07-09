   integer :: i
   character(len=1) :: c(20)
   equivalence (c, i)

   WRITE(*,*) bit_size(1)  ! number of bits in the default integer type
                           ! which may (or may not!) equal the word size
   i = 1

   IF (ichar(c(1)) == 0) THEN
      WRITE(*,*) "Big Endian"
   ELSE
     WRITE(*,*) "Little Endian"
   END IF
