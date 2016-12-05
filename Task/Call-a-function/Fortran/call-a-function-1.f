program main
implicit none
integer :: a
integer :: f, g
logical :: lresult
interface
  integer function h(a,b,c)
    integer :: a, b
    integer, optional :: c
  end function
end interface
write(*,*) 'no arguments: ', f()
write(*,*) '-----------------'
write(*,*) 'fixed arguments: ', g(5,8,lresult)
write(*,*) '-----------------'
write(*,*) 'optional arguments: ', h(5,8), h(5,8,4)
write(*,*) '-----------------'
write(*,*) 'function with variable arguments: Does not apply!'
write(*,*) 'An option is to pass arrays of variable lengths.'
write(*,*) '-----------------'
write(*,*) 'named arguments: ', h(c=4,b=8,a=5)
write(*,*) '-----------------'
write(*,*) 'function in statement context: Does not apply!'
write(*,*) '-----------------'
write(*,*) 'Fortran passes memory location of variables as arguments.'
write(*,*) 'So an argument can hold the return value.'
write(*,*) 'function result: ', g(5,8,lresult) , ' function successful? ', lresult
write(*,*) '-----------------'
write(*,*) 'Distinguish between built-in and user-defined functions: Does not apply!'
write(*,*) '-----------------'
write(*,*) 'Calling a subroutine: '
a = 30
call sub(a)
write(*,*) 'Function call: ', f()
write(*,*) '-----------------'
write(*,*) 'All variables are passed as pointers.'
write(*,*) 'Problems can arise if instead of sub(a), one uses sub(10).'
write(*,*) '-----------------'
end program

!no argument
integer function f()
f = 10
end function

!fixed number of arguments
integer function g(a, b, lresult)
integer :: a, b
logical :: lresult
g = a+b
lresult = .TRUE.
end function

!optional arguments
integer function h(a, b, c)
integer :: a, b
integer, optional :: c

h = a+b
if(present(c)) then
  h = h+10*c
end if
end function

!subroutine
subroutine sub(a)
integer :: a
a = a*100
write(*,*) 'Output of subroutine: ', a
end subroutine
