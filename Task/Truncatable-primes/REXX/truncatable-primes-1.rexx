/*REXX program finds largest left- and right-truncatable primes less than hi   */
Parse Arg hi .
If hi=='' Then
  hi=1000000                            /* Not specified? Then use default     */
Call genP                               /* generate primes up to hi            */

/* find largest left truncatable Prime */
Do l=prime.0 By -1                      /* search from top end;                */
  left.0=length(prime.l)
  Do k=1 For length(prime.l)
    _=right(prime.l,k)                  /* validate left truncatable ptime     */
    left.k=_
    If \is_prime._ Then
      Iterate l                         /* Truncated number not prime?  Skip   */
    End
  Leave
  End

/* find largest right truncated Prime */
Do r=prime.0 By -1                      /* search from top end;                */
  right.0=length(prime.r)
  Do k=1 For length(prime.r)
    _=left(prime.r,k)
    right.k=_
    If \is_prime._ Then
      Iterate r                         /* Truncated number not prime?  Skip   */
    End
  Leave
  End

Say 'The largest  left-truncatable prime smaller than' hi 'is' prime.l
do i=left.0-1 to 1 By -1
  say right(left.i,66)
  End
Say 'The largest right-truncatable prime smaller than' hi 'is' prime.r
do i=right.0-1 to 1 By -1
  say copies(' ',60)right.i
  End
Exit                                    /* stick a fork in it,  we're all done */
/*-----------------------------------------------------------------------------*/
genp:
  Call time 'R'
  Call init 2 3 5 7 11 13 17 19
  Do j=21 to hi By 2
    Select
      When right(j,1)=5 Then Iterate
      When j//3==0 Then Iterate
      When j//7==0 Then Iterate
      Otherwise Nop
      End
    Do k=5 While s.k<=j
      If j//prime.k==0 Then
        Iterate j
      End
    Call store j                        /* j is prime                          */
    End
  Say prime.0 'primes smaller than' hi '--'  time('E') 'seconds'
  Return

init:
  Parse Arg plist
  is_prime.=0
  prime.=0
  Do i=1 To words(plist)
    Call store word(plist,i)
    End
  Return

store:
  Parse Arg p
  z=prime.0+1
  prime.z=p
  s.z=p*p
  prime.0=z
  is_prime.p=1
  Return
