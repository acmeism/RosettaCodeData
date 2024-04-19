/*REXX program classifies various positive integers For types of aliquot sequences.*/
Parse Arg low high LL                       /*obtain optional arguments from the CL*/
high=word(high low 10,1)
low=word(low 1,1)                           /*obtain the  LOW  and  HIGH  (range). */
If LL='' Then
  LL=11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080
Numeric Digits 20                           /*be able To compute the number:  BIG  */
big=2**47
NTlimit=16+1                                /*limit for a non-terminating sequence */
Numeric Digits max(9,length(big))           /*be able To handle big numbers For // */
digs=digits()                               /*used For align numbers For the output*/
dsum.=.
dsum.0=0
dsum.1=0                                    /* dsum. are the proper divisor sums.  */
Say 'Numbers from ' low ' ---> ' high ' (inclusive):'
Do n=low To high                            /* process specified range             */
  Call classify n                           /* call subroutine To classify number. */
  End
Say
Say 'First numbers for each classification:'
class.=0                                    /* [?]  ensure one number of each class*/
Do q=1 Until class.sociable\==0             /*the only one that has To be counted. */
  Call classify  -q                         /*minus (-) sign indicates don't tell. */
  _=translate(what)                         /*obtain the class and uppercase it.   */
  class._=class._+1                         /*bump counter For this class sequence.*/
  If class._==1 Then                        /*first number of this class           */
    Call out q,what,dd
  End
Say                                         /* [?]  process Until all classes found*/
Say 'Classifications for specific numbers:'
Do i=1 To words(LL)                         /* process a list of "special numbers" */
  Call classify word(LL,i)                  /*call subroutine To classify number.  */
  End
Exit                                        /*stick a fork in it,we're all done.   */
out:
  Parse arg number,class,dd
  dd.=''
  Do di=1 By 1 While length(dd)>50
    do dj=50 To 10 By -1
      If substr(dd,dj,1)=' ' Then Leave
      End
    dd.di=left(dd,dj)
    dd=substr(dd,dj+1)
    End
  dd.di=dd
  Say right(number,digs)':' center(class,digs) dd.1||conti(1)
  Do di=2 By 1 While dd.di>''
    Say copies(' ',33)dd.di||conti(di)
    End
  Return
conti:
Parse arg this
next=this+1
If dd.next>'' Then Return '...'
Else Return ''
/*---------------------------------------------------------------------------------*/
classify:
  Parse Arg a 1 aa
  a=abs(a)                                  /*obtain number that's to be classified*/
  If dsum.a\==. Then
    s=dsum.a                                /*Was this number been  summed  before?*/
  Else
    s=dsum(a)                               /*No,Then classify number the hard way */
  dsum.a=s                                  /*define sum of the  proper divisors.  */
  dd=s                                      /*define the start of integer sequence.*/
  what='terminating'                        /*assume this kind of classification.  */
  c.=0                                      /*clear all cyclic sequences (to zero).*/
  c.s=1                                     /*set the first cyclic sequence.       */
  If dd==a Then
    what='perfect'                          /*check For a  "perfect"  number.      */
  Else Do t=1 By 1 While s>0                /*loop Until sum isn't  0   or   > big.*/
    m=s                                     /*obtain the last number in sequence.  */
    If dsum.m==. Then                       /*Not defined?                         */
      s=dsum(m)                             /* compute sum pro of per divisors     */
    Else
      s=dsum.m                              /*use the previously found integer.    */
    If m==s Then
      If m>=0 Then Do
        what='aspiring'
        Leave
        End
     If word(dd,2)=a Then Do
       what='amicable'
       Leave
       End
     dd=dd s                                /*append a sum To the integer sequence.*/
     If s==a Then
       If t>3 Then Do
         what='sociable'
         Leave
         End
     If c.s Then
       If m>0 Then Do
         what='cyclic'
         Leave
         End
     c.s=1                                  /*assign another possible cyclic number*/
                                            /* [?]  Rosetta Code task's limit: >16 */
     If t>NTlimit Then Do
       what='non-terminating'
       Leave
       End
     If s>big Then Do
       what='NON-TERMINATING'
       Leave
       End
     End
   If aa>0 Then                             /*  display only if  AA  is positive   */
     Call out a,what,dd
   Return
/*---------------------------------------------------------------------------------*/
dsum: Procedure Expose dsum.                /* compute the sum of proper divisors  */
  Parse Arg x
  If x<2 Then
    Return 0
  odd=x//2
  s=1                                       /* use EVEN or ODD integers.           */
  Do j=2+odd by 1+odd While j*j<x           /* divide by all the integers )        */
                                            /* up to but excluding sqrt(x)         */
    If x//j==0 Then                         /* j is a divisor, so is x%j           */
      s=s+j+x%j                             /*add the two divisors To the sum.     */
    End
  If j*j==x Then                            /* if x is a square                    */
    s=s+j                                   /* add sqrt(X)                         */
  dsum.x=s                                  /* memoize proper divisor sum of X     */
  Return s                                  /* return the proper divisor sum       */
