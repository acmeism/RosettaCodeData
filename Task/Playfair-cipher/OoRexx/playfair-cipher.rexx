/*---------------------------------------------------------------------
* REXX program implements a PLAYFAIR cipher (encryption & decryption).
* 11.11.2013 Walter Pachl revamped, for ooRexx, the REXX program
*                the logic of which was devised by Gerard Schildberger
* Invoke as rexx pf O abcd efgh ( phrase to be processed
* Defaults:           'Playfair example.'
*                   J
*                                 'Hide the gold in the tree stump'
* Major changes: avoid language elements not allowed in ooRexx
*                show use of a.[expr1,expr2]
*                allow key to be more than one word
*                add restriction of using X or Q in text
* 12.11.2013 change order of arguments
*            and comment the use of a.[expr1,expr2]
*            Program should run on all Rexxes that have changestr-bif
*--------------------------------------------------------------------*/
  Parse Upper Version v
  oorexx=pos('OOREXX',v)>0

  Parse Arg omit oldk '(' text
  If omit='' Then omit='J'
  If oldk='' Then oldk='Playfair example.'
  If text=''            Then text='Hide the gold in the tree stump!!'

  newkey=scrub(oldk,1)
  newtext=scrub(text)
  If newtext==''        Then Call err 'TEXT is empty or has no letters'
  If length(omit)\==1   Then Call err 'OMIT letter must be only one letter'
  If\datatype(omit,'M') Then Call err 'OMIT letter must be a Latin alphabet letter.'
  omit=translate(omit)
  cant='must not contain the "OMIT" character: ' omit
  If pos(omit,newtext)\==0 Then Call err 'TEXT' cant
  If pos(omit,newkey)\==0  Then Call err 'cipher key' cant
  abc='abcdefghijklmnopqrstuvwxyz'
  abcu=translate(abc)                 /* uppercase alphabet           */
  abcx=space(translate(abcu,,omit),0) /*elide OMIT char from alphabet */
  xx='X'                            /* char used for double characters*/
  If omit==xx Then
    xx='Q'
  If pos(xx,newtext)>0 Then
    Call err 'Sorry,' xx 'is not allowed in text'
  If length(newkey)<3 Then
    Call err 'cipher key is too short, must be at least 3 different letters'
  abcx=space(translate(abcx,,newkey),0) /*remove any cipher characters   */
  grid=newkey||abcx                     /* only first  25  chars are used*/
  Say 'old cipher key: ' strip(oldk)
  padl=14+2
  pad=left('',padl)
  Say 'new cipher key: ' newkey
  padx=left('',padl,"-")'Playfair'
  Say '     omit char: ' omit       /* [?]  lowercase of double char. */
  Say '   double char: ' xx
  lxx=translate(xx,abc,abcu)
  Say ' original text: ' strip(text)/* [?]  doubled version of  Lxx.  */
  Call show 'cleansed',newtext
  lxxlxx=lxx||lxx
  n=0                               /* number of grid characters used.*/
  Do row=1 For 5                    /* build array of individual cells*/
    Do col=1 For 5
      n=n+1
      a.row.col=substr(grid,n,1)
      If row==1 Then
        a.0.col=a.1.col
      If col==5 Then Do
        a.row.6=a.row.1
        a.row.0=a.row.5
        End
      If row==5 Then Do
        a.6.col=a.1.col
        a.0.col=a.5.col
        End
      End
    End

  etext=playfair(newtext,1)
  Call show 'encrypted',etext
  ptext=playfair(etext,-1)
  Call show 'plain',ptext
  qtext=changestr(xx||xx,ptext,lxx)     /*change doubled doublechar-?sing*/
  qtext=changestr(lxx||xx,qtext,lxxlxx) /*change Xx --? lowercase dblChar*/
  qtext=space(translate(qtext,,xx),0)   /*remove char used for "doubles."*/
  qtext=translate(qtext)                /*reinstate the use of upperchars*/
  Call show 'decoded',qtext
  Say ' original text: ' newtext        /* ·· and show the original text.*/
  Say ''
  Exit

playfair:
/*---------------------------------------------------------------------
* encode (e=1) or decode (e=-1) the given text (t) using the grid
*--------------------------------------------------------------------*/
  Arg t,e
  d=''
  If e=1 Then Do
    Do k=1 By 1 Until c=''
      c=substr(t,k,1)
      If substr(t,k+1,1)==c Then
        t=left(t,k)||lxx||substr(t,k+1)
      End
    End
  t=translate(t)
  Do j=1 By 2 To length(t)
    c2=strip(substr(t,j,2))
    If length(c2)==1 Then
      c2=c2||xx                         /* append X or Q char, rule 1*/
    Call LR
    Select
      /*- This could/should be used on ooRexx -------------------------
      When rowl==rowr Then c2=a.[rowl,coll+e]a.[rowr,colr+e] /*rule 2*/
      When coll==colr Then c2=a.[rowl+e,coll]a.[rowr+e,colr] /*rule 3*/
      *--------------------------------------------------------------*/
      When rowl==rowr Then c2=aa(rowl,coll+e)aa(rowr,colr+e) /*rule 2*/
      When coll==colr Then c2=aa(rowl+e,coll)aa(rowr+e,colr) /*rule 3*/
      Otherwise            c2=a.rowl.colr||a.rowr.coll       /*rule 4*/
      End
    d=d||c2
    End
  Return d

aa:
/*---------------------------------------------------------------------
* ooRexx allows to use a.[rowl,coll+e]
* this function can be removed when ooRexx syntax is used to access a.
*--------------------------------------------------------------------*/
  Parse Arg xrow,xcol
  Return a.xrow.xcol

err:
/*---------------------------------------------------------------------
* Exit with an error message
*--------------------------------------------------------------------*/
  Say
  Say '***error!***' arg(1)
  Say
  Exit 13

lr:
/*---------------------------------------------------------------------
* get grid positions of the 2 characters
*--------------------------------------------------------------------*/
  Parse Value rowcol(left(c2,1)) with rowl coll
  Parse Value rowcol(right(c2,1)) with rowr colr
  Return

rowcol: procedure Expose grid
/*---------------------------------------------------------------------
* compute row and column of the given character in the 5x5 grid
*--------------------------------------------------------------------*/
  Parse Arg c
  p=pos(c,grid)
  col=(p-1)//5+1
  row=(4+p)%5
  Return row col

show:
/*---------------------------------------------------------------------
* Show heading and text
*--------------------------------------------------------------------*/
  Arg,y
  Say
  Say right(arg(1) 'text: ',padl) digram(arg(2))
  result=space(arg(2),0)
  If arg(1)='decoded' Then Do
    result=strip(result,'T',xx)
    End
  Say pad result
  Return

scrub: Procedure
/*---------------------------------------------------------------------
* Remove all non-letters from the given string, uppercase letters
* and, if unique=1 remove duplicates
* 'aB + c1Bb' -> 'ABCBB' or 'ABC', respectively
*--------------------------------------------------------------------*/
  Arg xxx,unique                    /* ARG caps all args             */
  d=''
  used.=0
  Do While xxx<>''
    Parse Var xxx c +1 xxx
    If datatype(c,'U') Then
      If (unique=1 & pos(c,d)=0) |,
          unique<>1 Then
        d=d||c
    End
  Return d

digram: Procedure
/*---------------------------------------------------------------------
* Return the given string as character pairs separated by blanks
* 'ABCDEF' -> 'AB CD EF'
* 'ABCDE'  -> 'AB CD E'
*--------------------------------------------------------------------*/
  Parse Arg x
  d=''
  Do j=1 By 2 To length(x)
    d=d||substr(x,j,2)' '
    End
  Return strip(d)
