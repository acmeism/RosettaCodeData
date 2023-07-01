program Test
  use LongMoltiplication

  type(longnum) :: a, b, r

  call longmolt_s2l("18446744073709551616", a)
  call longmolt_s2l("18446744073709551616", b)

  r = a * b
  call longmolt_print(r)
  write(*,*)

end program Test
