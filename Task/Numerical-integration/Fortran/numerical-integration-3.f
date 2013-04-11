program IntegrationTest
  use Integration
  use FunctionHolder
  implicit none

  print *, integrate(afun, 0., 3**(1/3.), method='simpson')
  print *, integrate(afun, 0., 3**(1/3.), method='leftrect')
  print *, integrate(afun, 0., 3**(1/3.), method='midrect')
  print *, integrate(afun, 0., 3**(1/3.), method='rightrect')
  print *, integrate(afun, 0., 3**(1/3.), method='trapezoid')

end program IntegrationTest
