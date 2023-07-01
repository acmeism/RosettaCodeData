/*REXX program sorts a (stemmed) array using the  merge-sort method. */
/*   using mycmp function for the sort order                         */
/**********************************************************************
* mergesort taken from REXX (adapted for ooRexx (and all other REXXes))
* 28.07.2013 Walter Pachl
**********************************************************************/
  Call gena                        /* generate the array elements.   */
  Call showa 'before sort'         /* show the before array elements.*/
  Call mergeSort highitem          /* invoke the merge sort for array*/
  Call showa ' after sort'         /* show the  after array elements.*/
  Exit                             /* stick a fork in it, we're done.*/
/*---------------------------------GENa subroutine-------------------*/
gena:
  a.=''                            /* assign default value for a stem*/
  a.1='---The seven deadly sins---'/* everybody:  pick your favorite.*/
  a.2='==========================='
  a.3='pride'
  a.4='avarice'
  a.5='wrath'
  a.6='envy'
  a.7='gluttony'
  a.8='sloth'
  a.9='lust'
  Do highitem=1 While a.highitem\=='' /*find number of entries       */
    End
  highitem=highitem-1              /* adjust highitem by -1.         */
  Return
/*---------------------------------MERGETOa subroutine---------------*/
mergetoa: Procedure Expose a. !.
  Parse Arg l,n
  Select
    When n==1 Then
      Nop
    When n==2 Then Do
      h=l+1
      If mycmp(a.l,a.h)=1 Then Do
        _=a.h
        a.h=a.l
        a.l=_
        End
      End
    Otherwise Do
      m=n%2
      Call mergeToa l+m,n-m
      Call mergeTo! l,m,1
      i=1
      j=l+m
      Do k=l While k<j
        If j==l+n|mycmp(!.i,a.j)<>1 Then Do
          a.k=!.i
          i=i+1
          End
        Else Do
          a.k=a.j
          j=j+1
          End
        End
      End
    End
  Return
/*---------------------------------MERGESORT subroutine--------------*/
mergesort: Procedure Expose a.
  Call mergeToa 1,arg(1)
  Return
/*---------------------------------MERGETO! subroutine---------------*/
mergeto!: Procedure Expose a. !.
  Parse Arg l,n,_
  Select
    When n==1 Then
      !._=a.l
    When n==2 Then Do
      h=l+1
      q=1+_
      If mycmp(a.l,a.h)=1 Then Do
        q=_
        _=q+1
        End
      !._=a.l
      !.q=a.h
      Return
      End
    Otherwise Do
      m=n%2
      Call mergeToa l,m
      Call mergeTo! l+m,n-m,m+_
      i=l
      j=m+_
      Do k=_ While k<j
        If j==n+_|mycmp(a.i,!.j)<>1 Then Do
          !.k=a.i
          i=i+1
          End
        Else Do
          !.k=!.j
          j=j+1
          End
        End
      End
    End
  Return
/*---------------------------------SHOWa subroutine------------------*/
showa:
  widthh=length(highitem)           /* maximum the width of any line.*/
  Do j=1 For highitem
    Say 'element' right(j,widthh) arg(1)':' a.j
    End
  Say copies('-',60)                /* show a separator line (fence).*/
  Return

mycmp: Procedure
/**********************************************************************
* shorter string considered higher
* when lengths are equal: caseless 'Z' considered higher than 'X' etc.
* Result:  1  B consider higher than A
*         -1  A consider higher than B
*          0  A==B (caseless)
**********************************************************************/
  Parse Upper Arg A,B
    A=strip(A)
    B=strip(B)
    I = length(A)
    J = length(B)
    Select
      When I << J THEN res=1
      When I >> J THEN res=-1
      When A >> B THEN res=1
      When A << B THEN res=-1
      Otherwise        res=0
      End
    RETURN res
