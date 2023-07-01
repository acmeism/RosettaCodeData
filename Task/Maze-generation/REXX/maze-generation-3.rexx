/* REXX ***************************************************************
* 04.09.2013 Walter Pachl
**********************************************************************/
Parse Arg imax jmax seed
If imax='' Then imax=10
If jmax='' Then jmax=15
If seed='' Then seed=4711
c='123456789'||,
  'abcdefghijklmnopqrstuvwxyz'||,
  translate('abcdefghijklmnopqrstuvwxyz')
c=copies(c,10)
call random 1,10,seed
id=2*imax+1                         /* vertical dimension of a.i.j   */
jd=2*jmax+1                         /* horizontal dimension of a.i.j */
a.=1                                   /* mark all borders present   */
p.='.'                                 /* Initialize all grid points */
pl.=0                                  /* path list                  */
ii=random(1,imax)                      /* find a start position      */
jj=random(1,jmax)
p=1                                    /* first position             */
na=1                                   /* number of points used      */
Do si=1 To 1000                        /* Do Forever - see Leave     */
  /* Say 'loop' si na                     show progress              */
  Call path ii,jj                /* compute a path starting at ii/jj */
  If na=imax*jmax Then                 /* all points used            */
    Leave                              /* we are done                */
  Parse Value select_next() With ii jj /* get a new start from a path*/
  End

/***************
Do i=1 To imax
  ol=''
  Do j=1 To jmax
    ol=ol||p.i.j
    End
    Say ol
  End
Say ' '
***************/
Call show
/***********************
Do pi=1 To imax*jmax
  Say right(pi,3) pos.pi
  End
***********************/
Exit

path: Procedure Expose p. np. p pl. c a. na imax jmax id jd pos.
/**********************************************************************
* compute a path starting from point (ii,jj)
**********************************************************************/
  Parse Arg ii,jj
  p.ii.jj='1'
  pos.p=ii jj
  Do pp=1 to 50                /* compute a path of maximum length 50*/
    neighbors=neighbors(ii,jj)         /* number of free neighbors   */
    Select
      When neighbors=1 Then            /* just one                   */
        Call advance 1,ii,jj           /* go for it                  */
      When neighbors>0 Then Do         /* more Than 1                */
        ch=random(1,neighbors)         /* choose one possibility     */
        Call advance ch,ii,jj          /* and go for that            */
        End
      Otherwise                        /* none available             */
        Leave
      End
    End
  Return

neighbors: Procedure Expose p. np.  imax jmax neighbors pl.
/**********************************************************************
* count the number of free neighbors of point (i,j)
**********************************************************************/
  Parse Arg i,j
  neighbors=0
  in=i-1; If in>0     Then Call check in,j
  in=i+1; If in<=imax Then Call check in,j
  jn=j-1; If jn>0     Then Call check i,jn
  jn=j+1; If jn<=jmax Then Call check i,jn
  Return neighbors

check: Procedure Expose p. imax jmax np. neighbors pl.
/**********************************************************************
* check if point (i,j) is free and note it as possible successor
**********************************************************************/
  Parse Arg i,j
  If p.i.j='.' Then Do                 /* point is free              */
    neighbors=neighbors+1              /* number of free neighbors   */
    np.neighbors=i j                   /* note it as possible choice */
    End
  Return

advance: Procedure Expose p pos. np. p. c ii jj a. na pl. pos.
/**********************************************************************
* move to the next point of the current path
**********************************************************************/
  Parse Arg ch,pii,pjj
  Parse Var np.ch ii jj
  p=p+1                                /* position number            */
  pos.p=ii jj                          /* note its coordinates       */
  p.ii.jj=substr(c,p,1)                /* mark the point as used     */
  ai=pii+ii                            /* vertical border position   */
  aj=pjj+jj                            /* horizontal border position */
  a.ai.aj=0                            /* tear the border down       */
  na=na+1                              /* number of used positions   */
  z=pl.0+1                             /* add the point to the list  */
  pl.z=ii jj                           /* of follow-up start pos.    */
  pl.0=z
  Return

show: Procedure Expose id jd a.  na
/*********************************************************************
* Show the resulting maze
*********************************************************************/
  say 'mgg 6 18 4711'
  say 'show na='na
  Do i=1 To id
    ol=''
    Do j=1 To jd
      If i//2=1 Then Do                /* odd lines                 */
        If a.i.j=1 Then Do             /* border to be drawn        */
          If j//2=0 Then
            ol=ol||'---'               /* draw the border           */
          Else
            ol=ol'+'
          End
        Else Do                        /* border was torn down      */
          If j//2=0 Then
            ol=ol||'   '               /* blanks instead of border  */
          Else
            ol=ol||'+'
          End
        End
      Else Do                          /* even line                 */
        If a.i.j=1 Then Do
          If j//2=0 Then               /* even column               */
            ol=ol||'   '               /* moving space              */
          Else                         /* odd column                */
            ol=ol||'|'                 /* draw the border           */
          End
        Else                           /* border was torn down      */
          ol=ol||' '                   /* blank instead of border   */
        End
      End
    Select
      When i=6 Then ol=overlay('A',ol,11)
      When i=8 Then ol=overlay('B',ol, 3)
      Otherwise Nop
      End
    Say ol format(i,2)
    End
  Return

select_next: Procedure Expose p. pl. imax jmax
/*********************************************************************
* look for a point to start the nnext path
*********************************************************************/
  Do Until neighbors>0                 /* loop until one is found   */
    n=pl.0                             /* number of points recorded */
    s=random(1,n)                      /* pick a random index       */
    Parse Var pl.s is js               /* its coordinates           */
    neighbors=neighbors(is,js)         /* count free neighbors      */
    If neighbors=0 Then Do             /* if there is none          */
      pl.s=pl.n                        /* remove this point         */
      pl.0=pl.0-1
      End
    End
  Return is js                         /* return the new start point*/
