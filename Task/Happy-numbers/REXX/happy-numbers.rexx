/*REXX program computes and displays a specified range of happy numbers.         */
Call time 'R'
linesize=80
Parse Arg low high                        /* obtain range of happy numbers       */
If low='?' Then Call help
If low='' Then low=10
If high='' Then
  Parse Value 1 low With low high
Do i=0 To 9                               /*build a squared decimal digit table. */
  square.i=i*i
  End
happy.=0                                  /* happy.m=1 - m is a happy number     */
unhappy.=0                                /* unhappy.n=1 - n is an unhappy number*/
hapn=0                                    /* count of the happy numbers          */
ol=''
Do n=1 While hapn<high                    /* test integers starting with 1       */
  If unhappy.n Then                       /* if n  is unhappy,                   */
    Iterate                               /* then try next number                */
  work=n
  suml=''                                 /* list of computed sums               */
  Do Forever
    sum=0
    Do length(work)                       /* compute sum of squared digits       */
      Parse Var work digit +1 work
      sum=sum+square.digit
      End
    Select
      When unhappy.sum |,                 /* sum is known to be unhappy          */
           wordpos(sum,suml)>0 Then Do    /* or was already encountered          */
 --     If wordpos(sum,suml)>0 Then say 'Loop' n':' suml sum
 --     If n<7 Then say n':' suml sum
        unhappy.n=1                       /* n is unhappy                        */
        Call set suml                     /* amd so are all sums so far          */
        Iterate n
        End
      When sum=1 Then Do                  /* we reached sum=1                    */
        hapn+=1                           /* increment number of happy numbers   */
        happy.n=1                         /* n is happy                          */
        If hapn>=low Then                 /* if it is in specified range         */
          Call out n                      /* output it                           */
        If hapn=high Then                 /* end of range reached                */
          Leave n                         /* we are done                         */
        Iterate n                         /* otherwise proceed                   */
        End
      Otherwise Do                        /* otherwise                           */
        suml=suml sum                     /* add sum to list of sums             */
        work=sum                          /* proceed with the new sum            */
        End
      End
    End
  End
If ol>'' Then                             /* more output data                    */
  Say strip(ol)                           /* write to console                    */
-- Say time('E')
Exit

set:                                      /* all intermediate sums are unhappy   */
Parse Arg list
Do While list<>''
  Parse Var list s list
  unhappy.s=1
  End
Return

out:                                      /* output management                   */
  Parse Arg hn                            /* the happy number                    */
  If length(ol hn)>linesize Then Do       /* if it does not fit                  */
    Say strip(ol)                         /* output the line                     */
    ol=hn                                 /* and start a new line                */
    End
  Else                                    /* otherwise                           */
    ol=ol hn                              /* append is to the output line        */
  Return

help:
  Say 'rexx hno n compute and show the first n happy numbers'
  Say 'rexx hno low high      show happy numbers from index low to high'
  Exit
