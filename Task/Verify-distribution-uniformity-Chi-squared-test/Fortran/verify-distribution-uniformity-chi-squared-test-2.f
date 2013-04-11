program ChiTest
  use GSLMiniBind
  use iso_c_binding
  implicit none

  real, dimension(5) :: dset1 = (/ 199809., 200665., 199607., 200270., 199649. /)
  real, dimension(5) :: dset2 = (/ 522573., 244456., 139979.,  71531.,  21461. /)

  real :: dist, prob
  integer :: dof

  print *, "Dataset 1:"
  print *, dset1
  dist = chi2UniformDistance(dset1)
  dof = size(dset1) - 1
  write(*, '(A,I4,A,F12.4)') 'dof: ', dof, '   distance: ', dist
  prob = chi2Probability(dof, dist)
  write(*, '(A,F9.6)') 'probability: ', prob
  write(*, '(A,L)') 'uniform? ', chiIsUniform(dset1, 0.05)

  ! Lazy copy/past :|
  print *, "Dataset 2:"
  print *, dset2
  dist = chi2UniformDistance(dset2)
  dof = size(dset2) - 1
  write(*, '(A,I4,A,F12.4)') 'dof: ', dof, '   distance: ', dist
  prob = chi2Probability(dof, dist)
  write(*, '(A,F9.6)') 'probability: ', prob
  write(*, '(A,L)') 'uniform? ', chiIsUniform(dset2, 0.05)

contains

function chi2Probability(dof, distance)
  real :: chi2Probability
  integer, intent(in) :: dof
  real, intent(in) :: distance

  ! in order to make this work, we need linking with GSL library
  chi2Probability = gsl_sf_gamma_inc(real(0.5*dof, c_double), real(0.5*distance, c_double))
end function chi2Probability

function chiIsUniform(dset, significance)
  logical :: chiIsUniform
  real, dimension(:), intent(in) :: dset
  real, intent(in) :: significance

  integer :: dof
  real :: dist

  dof = size(dset) - 1
  dist = chi2UniformDistance(dset)
  chiIsUniform = chi2Probability(dof, dist) > significance
end function chiIsUniform

function chi2UniformDistance(ds)
  real :: chi2UniformDistance
  real, dimension(:), intent(in) :: ds

  real :: expected, summa = 0.0

  expected = sum(ds) / size(ds)
  summa = sum( (ds - expected) ** 2 )

  chi2UniformDistance = summa / expected
end function chi2UniformDistance

end program ChiTest
