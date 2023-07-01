/*- REXX --------------------------------------------------------------
* Brace expansion
* 26.07.2016
* s.* holds the set of strings
*--------------------------------------------------------------------*/
text.1='{,{,gotta have{ ,\, again\, }}more }cowbell!'
text.2='~/{Downloads,Pictures}/*.{jpg,gif,png}'
text.3='It{{em,alic}iz,erat}e{d,}, please. '
text.4='{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\} '
text.5='x{,a,b,c}{d,e}y'
text.6='aa{,{,11}cc}22'
text.7='{}'
Parse Arg dbg
oid='brace.xxx'; 'erase' oid
Do case=1 To 7
  Call brac text.case
  End
Return
brac:
  s.=0
  Parse Arg s
  Say ''
  Say '  's
  s.1.0=1                            /* first iteration              */
  s.1.1=s                            /* the initial string           */
  Do it=1 To 10 Until todo=0         /* Iterate until all done       */
    todo=0                           /* will be 1 if more to be done */
    Call dbg 'Iteration' it
    do di=1 To s.it.0                /* show current state           */
      Call dbg 's.'it'.'di  s.it.di
      End
    ita=it+1                         /* index for next set of strings*/
    xp=0
    do di=1 To s.it.0                /* loop over all strings        */
      Call dbg it'.'di s.it.di
      Call bra s.it.di               /* analyze current string       */
      If braces=1 Then Do            /* If brace groups were found   */
        Do bgi=1 To bgdata.0         /* loop over grace groups       */
          If end.bgi=0 Then Iterate  /* Incomplete bg (... )         */
          clist=''
          Do cj=1 To ci.bgi.0
            clist=clist ci.bgi.cj
            End
          Call dbg bgdata.bgi '->' clist
          If ccount.bgi>0 Then Do    /* comma(s) founf in bg         */
            Call expand bgi          /* expand this bg               */
            xp=1                     /* indicate that we worked      */
            Leave
            End
          End
        If xp=0 Then Do              /* nothing done                 */
          z=s.ita.0+1                /* copy string to next iteration*/
          s.ita.z=s.it.di
          End
        End
      Else Do                        /* no brace group               */
        z=s.ita.0+1                  /* copy string to next iteration*/
        s.ita.z=s
        s.ita.0=z
        End
      End
    Do dd=1 To s.ita.0               /* log current set of strings   */
      Call dbg ita dd s.ita.dd
      End
    End
  Do dd=1 To s.it.0                  /* show final set of strings    */
    Say dd s.it.dd
    End
  Return

bra:
/*---------------------------------------------------------------------
* Analyze the given string
* Input: s
* Output:
* bgdata.*  Array of data about brace groups:
*                      level start column comma positions end column
*--------------------------------------------------------------------*/
parse Arg s
Call dbg 'bra:' s
level=0
bgdata.=0
bgn=0
bgnmax=0
ccount.=0
ol=''
ci.=0
bgnl=''
braces=0
end.=0
escape=0
Do i=1 To length(s)
  c=substr(s,i,1)
  Select
    When escape Then
      escape=0
    When c='\' Then
      escape=1
    When c='{' Then Do
      level=level+1
      Call bm c
      co=level
      End
    When c='}' Then Do
      If level>0 Then Do
        co=level
        Call bm c
        level=level-1
        End
      End
    When c=',' Then Do
      co=level
      If co>0 Then Do
        ccount.bgn=ccount.bgn+1
        z=ccount.bgn
        ci.bgn.0=z
        ci.bgn.z=i
        End
      If ccount.bgn>0 Then
        braces=1
      End
    Otherwise
      co=level
    End
  ol=ol||co
  bgnl=bgnl||bgn
  End
Call dbg s
Call dbg ol
Call dbg left(copies('123456789.',10),length(s))
Call dbg bgnl
Do bgi=1 To bgdata.0
  If end.bgi=1 Then Do
    cl=''
    Do cii=1 To ci.bgi.0
      cl=cl ci.bgi.cii
      End
    Parse Var bgdata.bgi level a e
    Call dbg bgi level a cl e
    End
  End
Return

bm:
/*---------------------------------------------------------------------
* Brace Management
* for '{' create a new brace group )record level and start column
* for '}' look for corresponding bg and add end column
* Input: column and character ( '{' or '}' )
* Output: bgdata.*  level start-column [end-column]
*--------------------------------------------------------------------*/
  Parse Arg oc
  Call dbg oc i level
  If oc='{' Then Do
    z=bgdata.0+1
    bgdata.z=level i
    bgdata.0=z
    bgn=bgnmax+1
    bgnmax=bgn
    End
  Else Do
    Do bgi=bgdata.0 To 1 By -1
      If level=word(bgdata.bgi,1) Then Do
        bgdata.bgi=bgdata.bgi i
        end.bgi=1
        Leave
        End
      End
    bgn=bgn-1
    Call dbg bgdata.bgi 'bgn='bgn
    End
  Return

expand:
/*---------------------------------------------------------------------
* Expand a brace group in string s
*--------------------------------------------------------------------*/
  Parse Arg bgi
  Parse Var bgdata.bgi . start end
  clist=start clist end
  If words(clist)>0 Then Do          /* commas in brace group        */
    left=left(s,start-1)             /* part of s before the '{'     */
    rite=substr(s,end+1)             /* part of s after the '}'      */
    Do k=1 To words(clist)-1         /* Loop over comma positions    */
      a=word(clist,k)                /* start position               */
      e=word(clist,k+1)              /* end position                 */
      choice.k=substr(s,a+1,e-a-1)   /* one of the choices           */
      z=s.ita.0+1                    /* add new string to next set   */
      s.ita.z=left||choice.k||rite   /* construct new string         */
      s.ita.0=z
      todo=1                         /* maybe more to be done        */
      End
    End
  Else Do                            /* no commas                    */
    z=s.ita.0+1                      /* copy string as is to next set*/
    s.ita.z=s
    s.ita.0=z
    End
  Do zz=1 To s.ita.0
    Call dbg zz s.ita.zz
    End
  Return

dbg:                                 /* handle debug output          */
  If dbg<>'' Then                    /* argument given               */
    Say arg(1)                       /* show on screen               */
  Call lineout oid,arg(1)            /* write to file                */
  Return
