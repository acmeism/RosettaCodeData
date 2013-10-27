/*REXX program to demonstrate various methods of calling a REXX function*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function that REQUIRES no arguments.                     │
  │                                                                    │
  │ In the REXX language, there is no way to require the caller to not │
  │ pass arguments, but the programmer can check if any arguments were │
  │ (or weren't) passed.                                               │
  └────────────────────────────────────────────────────────────────────┘*/
yr=yearFunc()
say 'year=' yr
exit

yearFunc: procedure
if arg()\==0 then call sayErr "SomeFunc function won't accept arguments."
return left(date('Sorted'),3)
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function with a fixed number of arguments.               │
  │                                                                    │
  │ I take this to mean that the function requires a fixed number of   │
  │ arguments.   As above, REXX doesn't enforce calling (or invoking)  │
  │ a (any) function with a certain number of arguments,  but the      │
  │ programmer can check if the correct number of arguments have been  │
  │ specified (or not).                                                │
  └────────────────────────────────────────────────────────────────────┘*/
ggg=FourFunc(12,abc,6+q,zz%2,'da 5th disagreement')
say 'ggg squared=' ggg**2
exit

FourFunc: procedure; parse arg a1,a2,a3; a4=arg(4)  /*another way get a4*/

if arg()\==4 then do
                  call sayErr "FourFunc function requires 4 arguments,"
                  call sayErr "but instead it found" arg() 'arguments.'
                  exit 13
                  end
return a1+a2+a3+a4
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function with optional arguments.                        │
  │                                                                    │
  │ Note that not passing an argument isn't the same as passing a null │
  │ argument  (a REXX variable whose value is length zero).            │
  └────────────────────────────────────────────────────────────────────┘*/
x=12;  w=x/2;  y=x**2;  z=x//7                /* z  is  x  modulo seven.*/
say 'sum of w, x, y, & z=' SumIt(w,x,y,,z)    /*pass 5 args, 4th is null*/
exit

SumIt: procedure; sum=0

  do j=1 for arg()
  if arg(j,'E') then sum=sum+arg(j)  /*the Jth arg may have been omitted*/
  end

return sum
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function with a variable number of arguments.            │
  │                                                                    │
  │ This situation isn't any different then the previous example.      │
  │ It's up to the programmer to code how to utilize the arguments.    │
  └────────────────────────────────────────────────────────────────────┘*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function with named arguments.                           │
  │                                                                    │
  │ REXX allows almost anything to be passed, so the following is one  │
  │ way this can be accomplished.                                      │
  └────────────────────────────────────────────────────────────────────┘*/
what=parserFunc('name=Luna',"gravity=.1654",'moon=yes')
say 'name=' common.name
gr=common.gr
say 'gravity=' gr
exit

parseFunc: procedure expose common.
      do j=1 for arg()
      parse var arg(j) name '=' val
      upper name
      call value 'COMMON.'name,val
      end
return arg()
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function in statement context.                           │
  │                                                                    │
  │ REXX allows functions to be called (invoked) two ways, the first   │
  │ example (above) is calling a function in statement context.        │
  └────────────────────────────────────────────────────────────────────┘*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ Calling a function in within an expression.                        │
  │                                                                    │
  │ This is a variant of the first example.                            │
  └────────────────────────────────────────────────────────────────────┘*/
yr=yearFunc()+20
say 'two decades from now, the year will be:' yr
exit
/*┌────────────────────────────────────────────────────────────────────┐
  │ Obtaining the return value of a function.                          │
  │                                                                    │
  │ There are two ways to get the (return) value of a function.        │
  └────────────────────────────────────────────────────────────────────┘*/
currYear=yearFunc()
say 'the current year is' currYear

call yearFunc
say 'the current year is' result
/*┌────────────────────────────────────────────────────────────────────┐
  │ Distinguishing built-in functions and user-defined functions.      │
  │                                                                    │
  │ One objective of the REXX language is to allow the user to use any │
  │ function (or subroutine) name whether or not there is a built-in   │
  │ function with the same name  (there isn't a penality for this).    │
  └────────────────────────────────────────────────────────────────────┘*/
qqq=date()                      /*number of real dates that Bob was on. */
say "Bob's been out" qqq 'times.'
www='DATE'('USA')               /*returns date in format mm/dd/yyy      */
exit                            /*any function in quotes is external.   */

date: return 4
/*┌────────────────────────────────────────────────────────────────────┐
  │ Distinguishing subroutines and functions.                          │
  │                                                                    │
  │ There is no programatic difference between subroutines and         │
  │ functions if the subroutine returns a value  (which effectively    │
  │ makes it a function).   REXX allows you to call a function as if   │
  │ it were a subroutine.                                              │
  └────────────────────────────────────────────────────────────────────┘*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ In REXX, all arguments are passed by value, never by name,  but it │
  │ is possible to accomplish this if the variable's name is passed    │
  │ and the subroutine/function could use the built-in-function VALUE  │
  │ to retrieve the variable's value.                                  │
  └────────────────────────────────────────────────────────────────────┘*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ In the REXX language, partial application is possible, depending   │
  │ how partial application is defined; I prefer the 1st definition (as│
  │ (as per the "discussion" for "Partial Function Application" task:  │
  │   1.  The "syntactic sugar" that allows one to write (some examples│
  │       are:      map (f 7 9)  [1..9]                                │
  │        or:      map(f(7,_,9),{1,...,9})                            │
  └────────────────────────────────────────────────────────────────────┘*/
