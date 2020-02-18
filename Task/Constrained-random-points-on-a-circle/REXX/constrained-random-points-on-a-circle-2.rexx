/* REXX ---------------------------------------------------------------
* show 100 random points of an annulus with radius 10 to 15
* 18.06.2014 Walter Pachl 'derived/simplified' from REXX version 1
*--------------------------------------------------------------------*/
  Parse Arg points low high scale . /* allow parms from command line.*/
  If points=='' Then  points=100    /* number of points              */
  If low==''    Then  low=10        /* inner radius                  */
  If high==''   Then  high=15       /* outer radius                  */
  If scale==''  Then  scale=2       /* horizontal scaling            */
  low2=low**2
  high2=high**2
  /* first compute all possible points                               */
  point.=0
  Do x=-high To high
    x2=x*x
    Do y=-high To high
      y2=y*y
      s=x2+y2
      If s>=low2 &s<=high2 Then Do
        z=point.0+1
        point.z=x y
        point.0=z
        End
      End
    End
  plotchar='O'
  line.=''
  np=point.0                           /* available points           */
  Do j=1 To points                     /* pick the needed points     */
    r=random(1,np)
    Parse Var point.r x y              /* coordinates                */
    line.y=overlay(plotchar,line.y,scale*(x+high)+1) /* put into line*/
    point.r=point.np                   /* replace taken point by last*/
    np=np-1                            /* reduce available points    */
    If np=0 Then Leave                 /* all possible points taken  */
    End
/* now draw the picture                                              */
  Do y=-high To high
    Say line.y
    End
