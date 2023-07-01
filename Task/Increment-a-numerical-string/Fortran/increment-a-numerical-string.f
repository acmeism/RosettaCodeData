CHARACTER(10) :: intstr = "12345", realstr = "1234.5"
INTEGER :: i
REAL :: r

READ(intstr, "(I10)") i        ! Read numeric string into integer i
i = i + 1                      ! increment i
WRITE(intstr, "(I10)") i       ! Write i back to string

READ(realstr, "(F10.1)") r 	
r = r + 1.0				
WRITE(realstr, "(F10.1)") r
