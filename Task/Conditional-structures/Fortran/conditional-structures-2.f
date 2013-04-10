select case (i)
   case (21:)      ! matches all integers greater than 20
      q = q + i**2
   case (0:20)     ! matches all integers between 0 and 20 (inclusive)
      q = q + 2*i**3
   case default    ! matches all other integers (negative in this particular case)
      q = q - I
end select
