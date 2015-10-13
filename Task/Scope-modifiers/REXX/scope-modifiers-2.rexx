a=1
b=2
c=3
Call p  /* a Procedure  */
Say 'in m a b c x' a b c x
Call s  /* a subroutine */
Say 'in m a b c x' a b c x

Exit
p: Procedure Expose sigl b
Say 'in p sigl a b c' sigl a b c
Call s
Return
s:
Say 'in s sigl a b c' sigl a b c
x=4
Return
