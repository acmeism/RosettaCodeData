/*REXX program computes & displays the Recaman sequence           */
/*improved using version 1's method for task 3                    */
Call time 'R'                  /* Start timer                     */
Parse Arg n
If n='' Then n=15
Say 'the first' n 'elements:' recaman(n)
Say ans.2
Say ans.3
Say time('E') 'seconds elapsed'
Exit

recaman:
Parse Arg n                    /* Wanted number of elements       */
have.=0                        /* Number not yet in sequence      */
e.0=0                          /* First element                   */
have.0=1                       /*   is in the sequence            */
s=0                            /* Sequence to be shodn            */
done=0                         /* turn on first duplicate switch  */
d.=0
d.0=1
dn=1                           /* number of elements <=1000       */
 Do i=1 until dn==1001         /* Loop until all found            */
  ip=i-1                       /* previous index                  */
  temp=e.ip-i                  /* potential next element          */
  If temp>0 & have.temp=0 Then /*   to be used                    */
    Nop
  Else                         /* compute the alternative         */
    temp=e.ip+i
  e.i=temp                     /* Set next element                */
  If words(s)<n Then           /* not enough in output            */
    s=s temp                   /* add the element to the output   */
  If temp<=1000 Then Do        /* eligible for task 3             */
    If d.temp=0 Then Do        /* not yet encountered             */
      d.temp=1                 /* Remember it's there             */
      dn=dn+1                  /* count of integers<=1000 found   */
      End
    End
  If done=0 & have.temp=1 Then Do
    ans.2='First duplicate ('temp') added in iteration' i,
          'elapsed:' time('E') 'seconds'
    done=1
    End
  ans.3='Element number' i 'is the last to satisfy task 3. It is' temp
  Have.temp=1
  End
Return s
