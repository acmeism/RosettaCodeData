/* REXX ***************************************************************
* 04.08.2013 Walter Pachl using ooRexx features
*                   (maybe not in the best way -improvements welcome!)
*                   but trying to demonstrate the algorithm
**********************************************************************/
s.1=.array~of(.set~of('A','B'),.set~of('C','D'))
s.2=.array~of(.set~of('A','B'),.set~of('B','D'))
s.3=.array~of(.set~of('A','B'),.set~of('C','D'),.set~of('D','B'))
s.4=.array~of(.set~of('H','I','K'),.set~of('A','B'),.set~of('C','D'),,
              .set~of('B','D'),.set~of('F','G','H'))
s.5=.array~of(.set~of('snow','ice','slush','frost','fog'),,
              .set~of('iceburgs','icecubes'),,
              .set~of('rain','fog','sleet'))
s.6=.array~of('one')
s.7=.array~new
s.8=.array~of('')
Do si=1 To 8                           /* loop through the test data */
  na=s.si                              /* an array of sets           */
  head='Output(s):'
  Say left('Input' si,10) list_as(na)  /* show the input             */
  Do While na~items()>0                /* while the array ain't empty*/
    na=cons(na)                        /* consolidate and get back   */
                                       /*  array of remaining sets   */
    head='          '
    End
  Say '===='                           /* separator line             */
  End
Exit

cons: Procedure Expose head
/**********************************************************************
* consolidate the sets in the given array
**********************************************************************/
  Use Arg a
  w=a                                  /* work on a copy             */
  n=w~items()                          /* number of sets in the array*/
  Select
    When n=0 Then                      /* no set in array            */
      Return .array~new                /* retuns an empty array      */
    When n=1 Then Do                   /* one set in array           */
      Say head list(w[1])              /* show its contents          */
      Return .array~new                /* retuns an empty array      */
      End
    Otherwise Do                       /* at least two sets are there*/
      b=.array~new                     /* use for remaining sets     */
      r=w[n]                           /* start with last set        */
      try=1
      Do until changed=0               /* loop until result is stable*/
        changed=0
        new=0
        n=w~items()                    /* number of sets             */
        Do i=1 To n-try                /* loop first through n-1 sets*/
          try=0                        /* then through all of them   */
          is=r~intersection(w[i])
          If is~items>0 Then Do        /* any elements in common     */
            r=r~union(w[i])            /* result is the union        */
            Changed=1                  /* and result is now larger   */
            End
          Else Do                      /* no elemen in common        */
            new=new+1                  /* add the set to the array   */
            b[new]=w[i]                /* of remaining sets          */
            End
          End
        If b~items()=0 Then Do         /* no remaining sets          */
          w=.array~new
          Leave                        /* we are done                */
          End
        w=b                            /* repeat with remaining sets */
        b=.array~new                   /* prepare for next iteration */
        End
      End
    Say head list(r)                   /* show one consolidated set  */
    End
  Return w                             /* return array of remaining  */

list: Procedure
/**********************************************************************
* list elements of given set
**********************************************************************/
  Call trace ?O
  Use Arg set
  arr=set~makeArray
  arr~sort()
  ol='('
  Do i=1 To arr~items()
    If i=1 Then
      ol=ol||arr[i]
    Else
      ol=ol||','arr[i]
    End
  Return ol')'

list_as: Procedure
/**********************************************************************
* List an array of sets
**********************************************************************/
  Call trace ?O
  Use Arg a
  n=a~items()
  If n=0 Then
    ol='no element in array'
  Else Do
    ol=''
    Do i=1 To n
      ol=ol '('
      arr=a[i]~makeArray
      Do j=1 To arr~items()
        If j=1 Then
          ol=ol||arr[j]
        Else
          ol=ol','arr[j]
        End
      ol=ol') '
      End
    End
  Return strip(ol)
