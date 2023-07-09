/*REXX program  produces and displays a zig-zag  matrix (a square array) */
Parse Arg n start inc .   /* obtain optional arguments from command line */
if     n=='' |     n==","  then     n= 5 /*Not specified? use the default*/
if start=='' | start==","  then start= 0 /* "      "       "   "     "   */
if   inc=='' |   inc==","  then   inc= 1 /* "      "       "   "     "   */
Parse Value 1 1 n**2 With row col size
Do x=start By inc For size
  m.row.col=x
  If (row+col)//2=0 Then do  /* moving upward                            */
    Select
      when row=1 Then Do     /* at upper bound                           */
        If col<n Then
          col=col+1          /* move right                               */
        Else
          row=2              /* move down                                */
        End
      when col=n Then        /* at right border                          */
        row=row+1            /* move down                                */
      Otherwise Do           /* in all other cases                       */
        row=row-1            /* move up                                  */
        col=col+1            /* and to the right                         */
        End
      End
    End
  Else Do                    /* moving downward                          */
    Select
      When col=1 Then Do     /* at lower bound                           */
        If row=n Then        /* in bottom row                            */
          col=2              /* move right                               */
        Else                 /* otherwise                                */
          row=row+1          /* move down                                */
        End
      When row=n Then        /* at lower bound                           */
        col=col+1            /* move right                               */
      Otherwise Do           /* in all other cases                       */
        row=row+1            /* move down                                */
        col=col-1            /* and to the left                          */
        End
      End
    End
  End
Call show
Exit
/*-----------------------------------------------------------------------*/
show:
  w=length(start+size*inc)            /* max width of any matrix element */
  Do row=1 To n                       /* loop over rows                  */
    line=right(m.row.1,w)             /* first element                   */
    Do column=2 To n                  /* loop over other elements        */
      line=line right(m.row.column,w) /* build output line               */
      End
    Say line
    End                               /* display the line                */
  Return
