program Mean

  real :: a(10) = (/ (i, i=1,10) /)
  real :: amean, gmean, hmean

  amean = sum(a) / size(a)
  gmean = product(a)**(1.0/size(a))
  hmean = size(a) / sum(1.0/a)

  if ((amean < gmean) .or. (gmean < hmean)) then
    print*, "Error!"
  else
    print*, amean, gmean, hmean
  end if

end program Mean
