include setting
Say 'The product of smallest and greatest prime factors of numbers from 1 to 100:'
ol=''
do x=1 to 100
  ol=ol format(task(x),4)
  If x//10=0 Then Do
    say substr(ol,2)
    ol=''
    End
  end
Exit

task:
  Parse Arg x
  n=factors(x)              /* fact.1 to fact.n are the factors */
                            /* in ascending order               */
  If fact.0=1 Then          /* x is a prime number              */
    Return fact.1**2
  Else
    Return fact.1*fact.n

include math
