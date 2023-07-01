/*- REXX --------------------------------------------------------------
* pref.b  Preferences of boy b
* pref.g  Preferences of girl g
* boys    List of boys
* girls   List of girls
* plist   List of proposals
* mlist   List of (current) matches
* glist   List of girls to be matched
* glist.b List of girls that proposed to boy b
* blen    maximum length of boys' names
* glen    maximum length of girls' names
---------------------------------------------------------------------*/

pref.Charlotte=translate('Bingley Darcy Collins Wickham ')
pref.Elisabeth=translate('Wickham Darcy Bingley Collins ')
pref.Jane     =translate('Bingley Wickham Darcy Collins ')
pref.Lydia    =translate('Bingley Wickham Darcy Collins ')

pref.Bingley  =translate('Jane Elisabeth Lydia Charlotte')
pref.Collins  =translate('Jane Elisabeth Lydia Charlotte')
pref.Darcy    =translate('Elisabeth Jane Charlotte Lydia')
pref.Wickham  =translate('Lydia Jane Elisabeth Charlotte')

pref.ABE='ABI EVE CATH IVY JAN DEE FAY BEA HOPE GAY'
pref.BOB='CATH HOPE ABI DEE EVE FAY BEA JAN IVY GAY'
pref.COL='HOPE EVE ABI DEE BEA FAY IVY GAY CATH JAN'
pref.DAN='IVY FAY DEE GAY HOPE EVE JAN BEA CATH ABI'
pref.ED='JAN DEE BEA CATH FAY EVE ABI IVY HOPE GAY'
pref.FRED='BEA ABI DEE GAY EVE IVY CATH JAN HOPE FAY'
pref.GAV='GAY EVE IVY BEA CATH ABI DEE HOPE JAN FAY'
pref.HAL='ABI EVE HOPE FAY IVY CATH JAN BEA GAY DEE'
pref.IAN='HOPE CATH DEE GAY BEA ABI FAY IVY JAN EVE'
pref.JON='ABI FAY JAN GAY EVE BEA DEE CATH IVY HOPE'

pref.ABI='BOB FRED JON GAV IAN ABE DAN ED COL HAL'
pref.BEA='BOB ABE COL FRED GAV DAN IAN ED JON HAL'
pref.CATH='FRED BOB ED GAV HAL COL IAN ABE DAN JON'
pref.DEE='FRED JON COL ABE IAN HAL GAV DAN BOB ED'
pref.EVE='JON HAL FRED DAN ABE GAV COL ED IAN BOB'
pref.FAY='BOB ABE ED IAN JON DAN FRED GAV COL HAL'
pref.GAY='JON GAV HAL FRED BOB ABE COL ED DAN IAN'
pref.HOPE='GAV JON BOB ABE IAN DAN HAL ED COL FRED'
pref.IVY='IAN COL HAL GAV FRED BOB ABE ED JON DAN'
pref.JAN='ED HAL GAV ABE BOB JON COL IAN FRED DAN'

If arg(1)>'' Then Do
  Say 'Input from task description'
  boys='ABE BOB COL DAN ED FRED GAV HAL IAN JON'
  girls='ABI BEA CATH DEE EVE FAY GAY HOPE IVY JAN'
  End
Else Do
  Say 'Input from link'
  girls=translate('Charlotte Elisabeth Jane  Lydia')
  boys =translate('Bingley   Collins   Darcy Wickham')
  End

debug=0
blen=0
Do i=1 To words(boys)
  blen=max(blen,length(word(boys,i)))
  End
glen=0
Do i=1 To words(girls)
  glen=max(glen,length(word(girls,i)))
  End
glist=girls
mlist=''
Do ri=1 By 1 Until glist=''            /* as long as there are girls */
  Call dbg 'Round' ri
  plist=''                             /* no proposals in this round */
  glist.=''
  Do gi=1 To words(glist)              /* loop over free girls       */
    gg=word(glist,gi)                  /* an unmathed girl           */
    b=word(pref.gg,1)                  /* her preferred boy          */
    plist=plist gg'-'||b               /* remember this proposal     */
    glist.b=glist.b gg                 /* add girl to the boy's list */
    Call dbg left(gg,glen) 'proposes to' b  /* tell the user              */
    End
  Do bi=1 To words(boys)               /* loop over all boys         */
    b=word(boys,bi)                    /* one of them                */
    If glist.b>'' Then                 /* if he's got proposals      */
      Call dbg b 'has these proposals' glist.b /* show them               */
    End
  Do bi=1 To words(boys)               /* loop over all boys         */
    b=word(boys,bi)                    /* one of them                */
    bm=pos(b'*',mlist)                 /* has he been matched yet?   */
    Select
      When words(glist.b)=1 Then Do    /* one girl proposed for him  */
        gg=word(glist.b,1)             /* the proposing girl         */
        If bm=0 Then Do                /* no, he hasn't              */
          Call dbg b 'accepts' gg           /* is accepted                */
          Call set_mlist 'A',mlist b||'*'||gg /* add match to mlist  */
          Call set_glist 'A',remove(gg,glist) /* remove gg from glist*/
          pref.gg=remove(b,pref.gg)    /* remove b from gg's preflist*/
          End
        Else Do                        /* boy has been matched       */
          Parse Var mlist =(bm) '*' go ' ' /* to girl go             */
          If wordpos(gg,pref.b)<wordpos(go,pref.b) Then Do
               /* the proposing girl is preferred to the current one */
                                       /* so we replace go by gg     */
            Call set_mlist 'B',repl(mlist,b||'*'||gg,b||'*'||go)
            Call dbg b 'releases' go
            Call dbg b 'accepts ' gg
            Call set_glist 'B',glist go  /* add go to list of girls  */
            Call set_glist 'C',remove(gg,glist) /* and remove gg     */
            End
          pref.gg=remove(b,pref.gg)    /* remove b from gg's preflist*/
          End
        End
      When words(glist.b)>1 Then
        Call pick_1
      Otherwise Nop
      End
    End
  Call dbg 'Matches   :' mlist
  Call dbg 'free girls:' glist
  Call check 'L'
  End
Say 'Success at round' (ri-1)
Do While mlist>''
  Parse Var mlist boy '*' girl mlist
  Say left(boy,blen) 'matches' girl
  End
Exit

pick_1:
  If bm>0 Then Do                /* boy has been matched       */
    Parse Var mlist =(bm) '*' go ' ' /* to girl go             */
    pmin=wordpos(go,pref.b)
    End
  Else Do
    go=''
    pmin=99
    End
  Do gi=1 To words(glist.b)
    gt=word(glist.b,gi)
    gp=wordpos(gt,pref.b)
    If gp<pmin Then Do
      pmin=gp
      gg=gt
      End
    End
  If bm=0 Then Do
    Call dbg b 'accepts' gg           /* is accepted                */
    Call set_mlist 'A',mlist b||'*'||gg /* add match to mlist  */
    Call set_glist 'A',remove(gg,glist) /* remove gg from glist*/
    pref.gg=remove(b,pref.gg)    /* remove b from gg's preflist*/
    End
  Else Do
    If gg<>go Then Do
      Call set_mlist 'B',repl(mlist,b||'*'||gg,b||'*'||go)
      Call dbg b 'releases' go
      Call dbg b 'accepts ' gg
      Call set_glist 'B',glist go  /* add go to list of girls  */
      Call set_glist 'C',remove(gg,glist) /* and remove gg     */
      pref.gg=remove(b,pref.gg)  /* remove b from gg's preflist*/
      End
    End
  Return

remove:
  Parse Arg needle,haystack
  pp=pos(needle,haystack)
  If pp>0 Then
    res=left(haystack,pp-1) substr(haystack,pp+length(needle))
  Else
    res=haystack
  Return space(res)

set_mlist:
  Parse Arg where,new_mlist
  Call dbg 'set_mlist' where':' mlist
  mlist=space(new_mlist)
  Call dbg 'set_mlist ->' mlist
  Call dbg ''
  Return

set_glist:
  Parse Arg where,new_glist
  Call dbg 'set_glist' where':' glist
  glist=new_glist
  Call dbg 'set_glist ->' glist
  Call dbg ''
  Return

check:
  If words(mlist)+words(glist)<>words(boys) Then Do
    Call dbg 'FEHLER bei' arg(1) (words(mlist)+words(glist))'<>10'
    say 'match='mlist'<'
    say '   glist='glist'<'
    End
  Return

dbg:
  If debug Then
    Call dbg arg(1)
  Return
repl: Procedure
  Parse Arg s,new,old
  Do i=1 To 100 Until p=0
    p=pos(old,s)
    If p>0 Then
      s=left(s,p-1)||new||substr(s,p+length(old))
    End
  Return s
