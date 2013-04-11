program VectorProducts

  real, dimension(3)  :: a, b, c

  a = (/ 3, 4, 5 /)
  b = (/ 4, 3, 5 /)
  c = (/ -5, -12, -13 /)

  print *, dot_product(a, b)
  print *, cross_product(a, b)
  print *, s3_product(a, b, c)
  print *, v3_product(a, b, c)

contains

  function cross_product(a, b)
    real, dimension(3) :: cross_product
    real, dimension(3), intent(in) :: a, b

    cross_product(1) = a(2)*b(3) - a(3)*b(2)
    cross_product(2) = a(3)*b(1) - a(1)*b(3)
    cross_product(3) = a(1)*b(2) - b(1)*a(2)
  end function cross_product

  function s3_product(a, b, c)
    real :: s3_product
    real, dimension(3), intent(in) :: a, b, c

    s3_product = dot_product(a, cross_product(b, c))
  end function s3_product

  function v3_product(a, b, c)
    real, dimension(3) :: v3_product
    real, dimension(3), intent(in) :: a, b, c

    v3_product = cross_product(a, cross_product(b, c))
  end function v3_product

end program VectorProducts
