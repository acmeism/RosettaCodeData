say ggx1('4.0 0.0 6.0 10.0 0.0 3.0 10.0 7.0')
say ggx1('0.0 0.0 0.0 10.0 0.0 3.0 10.0 7.0')
say ggx1('0.0 0.0 0.0 10.0 0.0 3.0 10.0 7.0')
say ggx1('0.0 0.0 0.0  1.0 1.0 0.0  1.0 7.0')
say ggx1('0.0 0.0 0.0  0.0 0.0 3.0 10.0 7.0')
say ggx1('0.0 0.0 3.0  3.0 0.0 0.0  6.0 6.0')
say ggx1('0.0 0.0 3.0  3.0 0.0 1.0  6.0 7.0')
Exit

ggx1: Procedure
/*---------------------------------------------------------------------
* find the intersection of the lines AB and CD
*--------------------------------------------------------------------*/
Parse Arg xa  ya  xb  yb   xc  yc  xd   yd
Say 'A=('xa'/'ya') B=('||xb'/'yb') C=('||xc'/'yc') D=('||xd'/'yd')'
res=''
If xa=xb Then Do                    /* AB is a vertical line         */
  k1='*'                            /* slope is infinite             */
  x1=xa                             /* intersection's x is xa        */
  If ya=yb Then                     /* coordinates are equal         */
    res='Points A and B are identical' /* special case               */
  End
Else Do                             /* AB is not a vertical line     */
  k1=(yb-ya)/(xb-xa)                /* compute the slope of AB       */
  d1=ya-k1*xa                /* and its intersection with the y-axis */
  End
If xc=xd Then Do                    /* CD is a vertical line         */
  k2='*'                            /* slope is infinite             */
  x2=xc                             /* intersection's x is xc        */
  If yc=yd Then                     /* coordinates are equal         */
    res='Points C and D are identical' /* special case               */
  End
Else Do                             /* CD is not a vertical line     */
  k2=(yd-yc)/(xd-xc)                /* compute the slope of CD       */
  d2=yc-k2*xc                /* and its intersection with the y-axis */
  End

If res='' Then Do                   /* no special case so far        */
  If k1='*' Then Do                 /* AB is vertical                */
    If k2='*' Then Do               /* CD is vertical                */
      If x1=x2 Then                 /* and they are identical        */
        res='Lines AB and CD are identical'
      Else                          /* not identical                 */
        res='Lines AB and CD are parallel'
      End
    Else Do
      x=x1                          /* x is taken from AB            */
      y=k2*x+d2                     /* y is computed from CD         */
      End
    End
  Else Do                           /* AB is not verical             */
    If k2='*' Then Do               /* CD is vertical                */
      x=x2                          /* x is taken from CD            */
      y=k1*x+d1                     /* y is computed from AB         */
      End
    Else Do                         /* AB and CD are not vertical    */
      If k1=k2 Then Do              /* identical slope               */
        If d1=d2 Then               /* same intersection with x=0    */
          res='Lines AB and CD are identical'
        Else                        /* otherwise                     */
          res='Lines AB and CD are parallel'
        End
      Else Do                       /* finally the normal case       */
        x=(d2-d1)/(k1-k2)           /* compute x                     */
        y=k1*x+d1                   /* and y                         */
        End
      End
    End
  End
  If res='' Then                    /* not any special case          */
    res='Intersection is ('||x'/'y')'  /* that's the result          */
  Return '  -->' res
