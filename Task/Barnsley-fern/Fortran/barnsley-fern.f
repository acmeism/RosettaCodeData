!Generates an output file "plot.dat" that contains the x and y coordinates
!for a scatter plot that can be visualized with say, GNUPlot
program BarnsleyFern
implicit none

double precision :: p(4), a(4), b(4), c(4), d(4), e(4), f(4), trx, try, prob
integer :: itermax, i

!The probabilites and coefficients can be modified to generate other
!fractal ferns, e.g. http://www.home.aone.net.au/~byzantium/ferns/fractal.html
!probabilities
p(1) = 0.01; p(2) = 0.85; p(3) = 0.07; p(4) = 0.07

!coefficients
a(1) =  0.00; a(2) =  0.85; a(3) =  0.20; a(4) = -0.15
b(1) =  0.00; b(2) =  0.04; b(3) = -0.26; b(4) =  0.28
c(1) =  0.00; c(2) = -0.04; c(3) =  0.23; c(4) =  0.26
d(1) =  0.16; d(2) =  0.85; d(3) =  0.22; d(4) =  0.24
e(1) =  0.00; e(2) =  0.00; e(3) =  0.00; e(4) =  0.00
f(1) =  0.00; f(2) =  1.60; f(3) =  1.60; f(4) =  0.44

itermax = 100000

trx = 0.0D0
try = 0.0D0

open(1, file="plot.dat")
write(1,*) "#X            #Y"
write(1,'(2F10.5)') trx, try

do i = 1, itermax
  call random_number(prob)
  if (prob < p(1)) then
    trx = a(1) * trx + b(1) * try + e(1)
    try = c(1) * trx + d(1) * try + f(1)
  else if(prob < (p(1) + p(2))) then
    trx = a(2) * trx + b(2) * try + e(2)
    try = c(2) * trx + d(2) * try + f(2)
  else if ( prob < (p(1) + p(2) + p(3))) then
    trx = a(3) * trx + b(3) * try + e(3)
    try = c(3) * trx + d(3) * try + f(3)
  else
    trx = a(4) * trx + b(4) * try + e(4)
    try = c(4) * trx + d(4) * try + f(4)
  end if
  write(1,'(2F10.5)') trx, try
end do
close(1)
end program BarnsleyFern
