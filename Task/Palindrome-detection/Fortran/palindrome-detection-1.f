program palindro

  implicit none

  character(len=*), parameter :: p = "ingirumimusnocteetconsumimurigni"

  print *, is_palindro_r(p)
  print *, is_palindro_r("anothertest")
  print *, is_palindro2(p)
  print *, is_palindro2("test")
  print *, is_palindro(p)
  print *, is_palindro("last test")

contains
