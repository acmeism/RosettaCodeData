/* REXX ***************************************************************
* 29.07.2013 Walter Pachl trying to address the task concisely
***********************************************************************
* f1 Calling a function that requires no arguments
* f2 Calling a function with a fixed number of arguments
* f3 Calling a function with optional arguments
* f4 Calling a function with a variable number of arguments
* f5 Calling a function with named arguments
* f6 Using a function in statement context
* f7 Using a function within an expression
* f8 Obtaining the return value of a function
*       f8(...) is replaced by the returned value
*       call f8 ...  returned value is in special vatiable RESULT
* f9 Distinguishing built-in functions and user-defined functions
*       bif is enforced by using its name quoted in uppercase
* fa,fb Distinguishing subroutines and functions
* Stating whether arguments are passed by value or by reference
*       Arguments are passed by value
*       ooRexx supports passing by reference (Use Arg instruction)
* Is partial application possible and how
*       no ideas
**********************************************************************/
say f1()
Say f2(1,2,3)
say f2(1,2,3,4)
say f3(1,,,4)
Say f4(1,2)
Say f4(1,2,3)
a=4700; b=11;
Say f5('A','B')
f6()  /* returned value is used as command */
x=f7()**2
call f8 1,2; Say result '=' f8(1,2)
f9: Say 'DATE'('S') date()
call fa 11,22; Say result '=' fa(1,,
                                   2) /* the second comma above is for line continuation */
Signal On Syntax
Call fb 1,2
x=fb(1,2)
Exit
f1: Return 'f1 doesn''t need an argument'
f2: If arg()=3 Then
      Return 'f2: Sum of 3 arguments:' arg(1)+arg(2)+arg(3)
    Else
      Return 'f2: Invalid invocation:' arg() 'arguments. Needed: 3'
f3: sum=0
    do i=1 To arg()
      If arg(i,'E')=0 Then Say 'f3: Argument' i 'omitted'
                      Else sum=sum+arg(i)
      End
    Return 'f3 sum=' sum
f4: sum=0; Do i=1 To arg(); sum=sum+arg(i); End
    Return 'f4: Sum of' arg() 'arguments is' sum
f5: Parse Arg p1,p2
    Say 'f5: Argument 1 ('p1') contains' value(p1)
    Say 'f5: Argument 2 ('p2') contains' value(p2)
    Return 'f5: sum='value(p1)+value(p2)
f6: Say 'f6: dir ft.rex'
    Return 'dir ft.rex'
f7: Say 'f7 returns 7'
    Return 7
f8: Say 'f8 returns arg(1)+arg(2)'
    Return arg(1)+arg(2)
date: Say 'date is my date function'
    Return translate('ef/gh/abcd','DATE'('S'),'abcdefgh')
fa: Say 'fa returns arg(1)+arg(2)'
    Return arg(1)+arg(2)
fb: Say 'fb:' arg(1)','arg(2)
    Return

Syntax:
  Say 'Syntax raised in line' sigl
  Say sourceline(sigl)
  Say 'rc='rc '('errortext(rc)')'
  If sigl=39 Then
    Say 'fb cannot be invoked as function (it does not return a value'
  Exit
