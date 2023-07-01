/* REXX ****************************************** Version 11.12.2015 **
* Rexx Tokenizer to find function invocations
*-----------------------------------------------------------------------
* Tokenization remembers the following for each token
* t.i       text of token
* t.i.0t    type of token: Cx/V/K/N/O/S/L
*             comment/variable/keyword/constant/operator/string/label
* t.i.0il   line of token in the input
* t.i.0ic   col of token in the input
* t.i.0prev index of token starting previous instruction
* t.i.0ol   line of token in the output
* t.i.0oc   col of token in the output
*---------------------------------------------------------------------*/
  Call time 'R'
  Parse Upper Arg fid '(' options
  If fid='?' Then Do
    Say 'Tokenike a REXX proram and list the function invocations found'
    Say '  which are of the form symbol(... or ''string''(...'
    Say '  (the left parenthesis must immediately follow the symbol'
    Say '  or literal string.)'
    Say 'Syntax:'
    Say '  TKZ pgm < ( <Debug> <Tokens> >'
    Exit
    End
  g.=0
  Call init                         /* Initialize constants etc.      */
  g.0cont='01'x
  g.0breakc='02'x
  cnt.=0
  Call readin                       /* Read input file into l.*       */
  Call tokenize                     /* Tokenize the input             */
  tk=''
  Call process_tokens
  g.0fun_list=wordsort(g.0fun_list)
  Do While g.0fun_list>''
    Parse Var g.0fun_list fun g.0fun_list
    Say right(cnt.fun,3) fun
    End
  Say time('E') 'seconds elapsed for' t.0 'tokens in' g.0lines 'lines.'
  Exit

init:
/***********************************************************************
* Initialize constants etc.
***********************************************************************/
  g.=''
  g.0debug=0                        /* set debug off by default       */

  fid=strip(fid)
  If fid='' Then                    /* no file specified              */
    Exit exit(12 'no input file specified')
  Parse Var fid fn '.'

  os=options                        /* options specified on command   */
  g.0debug=0                        /* turn off debug output          */
  g.0tokens=0                       /* No token file                  */
  Do While os<>''                   /* process them individually      */
    Parse Upper Var os o os         /* pick one                       */
    Select
      When abbrev('DEBUG',o,1) Then /* Debug specified                */
        g.0debug=1                  /* turn on debug output           */
      When abbrev('TOKENS',o,1) Then /* Write a file with tokens      */
        g.0tokens=1
      Otherwise                     /* anything else                  */
        Say 'Unknown option:' o     /* tell the user and ignore it    */
      End
    End

  If g.0debug Then Do
    g.0dbg=fn'.dbg'; '@erase' g.0dbg
    End
  If g.0tokens Then Do
    g.0tkf=fn'.tok'; '@erase' g.0tkf
    End

/***********************************************************************
* Language specifics
***********************************************************************/
  g.0special='+-*/%''";:<>^\=|,()& '/* special characters             */
                                        /* chars that may start a var */
  g.0a='abcdefghijklmnopqrstuvwxyz'||,
       'ABCDEFGHIJKLMNOPQRSTUVWXYZ@#$!?_'
  g.0n='1234567890'                 /* numeric characters             */
  g.0vc=g.0a||g.0n||'.'             /* var-character                  */
                                    /* multi-character operators      */
  g.0opx='&& ** // << <<= <= <> == >< >= >> >>=',
         '^< ^<< ^= ^== ^> ^>> \< \<< \= \== \> \>> ||'

  t.=''                             /* token list                     */
  Return

readin:
/***********************************************************************
* Read the file to be formatted
***********************************************************************/
  lc=''
  i=0
  g.0lines=0
  Do While lines(fid)<>0
    li=linein(fid)
    g.0lines=g.0lines+1
    If i>0 Then
      lc=strip(l.i,'T')
    If right(lc,1)=',' Then Do
      l.i=left(lc,length(lc)-1) li
      End
    Else Do
      i=i+1
      l.i=li
      End
    End
  l.0=i
  Call lineout fid
  t=l.0+1
  l.t=g.0eof                        /* add a stopper at program end   */
  l.0=t                             /* adjust number of lines         */
  g.0il=t                           /* remember end of program        */
  Return

tokenize:
/***********************************************************************
* First perform tokenization
* Input:  l.*  Program text
* Output: t.*  Token list
*         t.0t.i token type CA CB CC C comment begin/middle/end
*                           S          string
*                           O          operator (special character)
*                           V          variable symbol
*                           N          constant
*                           X          end of text
* Note: special characters are treated as separate tokens
***********************************************************************/
  li=0                              /* line index                     */
  ti=0                              /* token index                    */
  Do While li<l.0                   /* as long as there is more input */
    li=li+1                         /* index of next line             */
    l=l.li                          /* next line to be processed      */
    g.0newline=1
    g.0cc=0                         /* current column                 */
    Call dsp l.li                   /* debug output                   */
    If l='' Then                    /* empty line                     */
      Call addtoken '/*--*/','C'    /* preserve with special token    */
    Do While l<>''                  /* work through the line          */
      nbc=verify(l,' ')             /* first non-blank column         */
      g.0cc=g.0cc+nbc               /* advance to this                */
      If g.0newline='' Then Do
        If t.ti.0ic='' Then
          t.ti.0ic=0
        If g.0cc=t.ti.0ic+length(t.ti) Then Do
          tj=ti+1
          t.tj.0ad=1
          End
        End
      l=substr(l,nbc)               /* and continue with rest of line */
      Parse Var l c +1 l 1 c2 +2    /* get character(s)               */
      g.0tb=g.0cc                   /* remember where token starts    */
      Select                        /* take a decision                */
        When c2='/*' Then           /* comment starts here            */
          Call comment              /* process comment                */
        When pos(c,'''"')>0 Then    /* literal string starts here     */
          Call string c             /* process literal string         */
        Otherwise                   /* neither comment nor literal    */
          Call token                /* get other token                */
        End                         /* cmt, string, or token done     */
      End                           /* end of loop over line          */
    End                             /* end of loop over program       */
  t.0=ti                            /* store number of tokens         */
  Call dsp ti 'tokens' l.0 'lines'
  Return
comment:
/***********************************************************************
* Parse a comment
* Nested comments are supported
***********************************************************************/
  cbeg=t.ti.0il
  l=substr(l,2)                     /* continue after slash-asterisk  */
  g.0cc=g.0cc+1                     /* update current char position   */
  t='/*'                            /* token so far                   */
  incmt=1                           /* indicate "within a comment"    */
  Do Until incmt=0                  /* loop until done                */
    bc=pos('/*',l)                  /* next begin comment, if any     */
    ec=pos('*/',l)                  /* next end   comment, if any     */
    Select                          /* decide                         */
      When bc>0 &,                  /* begin-comment found            */
           (ec=0 | bc<ec) Then Do   /* and no end-comment or later    */
        t=t||left(l,bc+1)           /* add this all to token          */
        incmt=incmt+1               /* increment comment nest-depth   */
        l=substr(l,bc+2)            /* continue after slash-asterisk  */
        g.0cc=g.0cc+bc+1            /* update current char position   */
        End
      When ec>0 Then Do             /* end-comment found              */
        t=t||left(l,ec+1)           /* add all to token               */
        incmt=incmt-1               /* decrement nesting              */
        l=substr(l,ec+2)            /* continue after asterisk-slash  */
        g.0cc=g.0cc+ec+1            /* update current char position   */
        End
      Otherwise Do                  /* no further comment bracket     */
        Call addtoken t||l,ct()     /* rest of line to token          */
        li=li+1                     /* proceed to next line           */
        l=l.li                      /* contents of next line          */
        g.0newline=1
        If l=g.0eof Then Do
          Say 'Comment started in line' cbeg 'is not closed before EOF'
          Exit err(58)
          End
        g.0cc=0                     /* current char (none)            */
        g.0tb=1                     /* token (comment) starts here    */
        End
      End
    End
  Call addtoken t,ct()             /* last (or only) comment token    */
  If pos('*debug*',t)>0 Then g.0debug=1
  Return

ct:
/***********************************************************************
* Comment type
***********************************************************************/
  If incmt>0 Then Do                /* within a comment               */
    If t.ti.0t='CA' |,              /* prev. token was start or cont  */
       t.ti.0t='CB' Then Return 'CB'  /* this is continuation         */
                    Else Return 'CA'  /* this is start                */
    End
  Else Do                           /* comment is over                */
    If t.ti.0t='CA' |,              /* prev. token was start or cont  */
       t.ti.0t='CB' Then Return 'CC'  /* this is final part           */
                    Else Return 'C'   /* this is just a comment       */
    End
string:
/***********************************************************************
* Parse a string
* take care of '111'B and '123'X
***********************************************************************/
  Parse Arg delim                  /* string delimiter found          */
  t=delim                          /* star building the token         */
  instr=1                          /* note we are within a string     */
  g.0ss=li
  Do Until instr=0                 /* continue until it is over       */
    se=pos(delim,l)                /* ending delimiter                */
    If se>0 Then Do                /* found                           */
      If substr(l,se+1,1)=delim Then Do /* but it is doubled          */
        t=t||left(l,se+1)          /* so add all so far to token      */
        l=substr(l,se+2)           /* and take rest of line           */
        g.0cc=g.0cc+se+1           /* and set current character pos   */
        End
      Else Do                      /* not another one                 */
        instr=0                    /* string is done                  */
        t=t||left(l,se)            /* add the string data to token    */
        l=substr(l,se+1)           /* take the rest of the line       */
        g.0cc=g.0cc+se             /* and set current character pos   */
        If pos(translate(left(l,1)),'BX')>0 Then
          If pos(substr(l,2,1),g.0vc)=0 Then Do
            t=t||left(l,1)         /* add the char to the token       */
            l=substr(l,2)          /* take the rest of the line       */
            g.0cc=g.0cc+1          /* and set current character pos   */
            End
        End
      End
    Else Do                        /* not found                       */
      Call addtoken t||l,'S'       /* store the token                 */
      g.0lasttoken=''              /* reset this switch               */
      li=li+1                      /* go on to the next line          */
      If li>l.0 Then               /* there is no next line           */
        Exit err(60,'string starting in line' g.0ss,
                                      'does not end before end of file')
      Else
        Say 'string starting at line' g.0ss 'extended over line boundary'
      l=l.li                       /* take contents of the next line  */
      g.0cc=1                      /* current char position           */
      g.0tb=1                      /* ??                              */
      End
    End
  Call addtoken t,'S'              /* store the token                 */
  Return
token:
/***********************************************************************
* Parse a token
***********************************************************************/
  IF c=g.0comma & l='' Then Do
    t=g.0cont
    type='O'                        /* O (for operator - not quite...)*/
    End
  Else Do
    If pos(c,g.0special)>0 Then Do  /* a special character            */
      t=c                           /* take it as is                  */
      type='O'                      /* O (for operator - not quite...)*/
      End
    Else Do                         /* some other character           */
      nsp=verify(l,g.0special,'M')  /* find delimiting character      */
      If nsp>0 Then Do              /* some character found           */
        t=c||left(l,nsp-1)          /* take all up to this character  */
        l=substr(l,nsp)             /* and continue from there        */
        End
      Else Do                       /* none found                     */
        t=c||l                      /* add rest of line to token      */
        l=''                        /* and all is used up             */
        End
      g.0cc=g.0cc+length(t)-1       /* adjust current char position   */
      If pos(right(t,1),'eE')>0 &,  /* consider nxxxE+nn case         */
         pos(left(l,1),'+-')>0 Then Do
        If pos(left(t,1),'.1234567890')>0 Then /* start . or digit    */
          If pos(substr(l,2,1),'1234567890')>0 Then Do /* dig after+- */
            nsp=verify(substr(l,2),g.0special,'M')+1 /* find end      */
            If nsp>1 Then           /* delimiting character found     */
              exp=substr(l,2,nsp-2)   /* exponent (if numeric)        */
            Else
              exp=substr(l,2)
          If verify(exp,'0123456789')=0 Then Do
            t=t||left(l,1)||exp
            l=substr(l,length(exp)+2)
            g.0cc=g.0cc+length(exp)+2
            End
          End
        End
      Select
        When isvar(t) Then          /* token qualifies as variable    */
          type='V'
        When isconst(t) Then        /* token is a constant symbol     */
          type='N'
        When t=g.0eof   Then        /* token is end of file indication*/
          type='X'
        Otherwise Do                /* anything else is an error      */
          Say 'li='li
          Say l
          Say 'token error'
          Trace ?R
          Exit err(62,'token' t 'is neither variable nor constant')
          End
        End
      If left(l,1)='(' Then
        type=type||'F'
      End
    End
  Call addtoken t,type              /* store the token                */
  Return
addtoken:
/***********************************************************************
* Add a token to the token list
***********************************************************************/
  Parse Arg t,type                  /* token and its type             */
  If type='O' Then Do               /* operator (special character)   */
    If pos(t,'><=&|/*')>0 Then Do   /* char for composite operator    */
      If wordpos(t.ti||t,g.0opx)>0 Then Do  /*  composite operator    */
        t.ti=t.ti||t                /* use concatenation              */
                                    /* does not handle =/**/=         */
        t=''                        /* we are done                    */
        Return
        End
      End
    End

  If type='CC' & t='*/' Then Do     /* The special case for SPA       */
    Return
    End

  ti=ti+1                           /* increment index                */
  t.ti=t                            /* store token's value            */
  t.ti.0t=left(type,1)              /*  and its type                  */
  t.ti.0nl=g.0newline               /* token starts a new line        */
  g.0newline=''                     /* reset new line switch          */
  If t.ti.0t='C' Then Do
    t.ti.0t=type
    If left(t.ti,3)='/* ' &,
       right(t.ti,3)=' */' Then
      t.ti='/*' strip(substr(t.ti,4,length(t.ti)-6)) '*/'
    End
  t.ti.0f=substr(type,2,1)          /* 'F' if possibly a function     */
  Call setpos ti li g.0tb           /*    and its position            */
  If left(type,1)='C' Then          /* ??? */
    If left(t.ti,2)<>'/*' Then Do
      ts=strip(t.ti,'L')
      t.ti.0oc=t.ti.0oc+length(t.ti)-length(ts)
      t.ti=ts
      End
  If t.ti.0ol='' Then t.ti.0ol=li
  If t.ti.0oc='' Then t.ti.0oc=0
  t.ti.0il=t.ti.0ol                 /*    and its position            */
  t.ti.0ic=t.ti.0oc                 /*    and its position            */
  Call dsp ti t.ti t.ti.0il'/'t.ti.0ic '->' t.ti.0ol'/'t.ti.0oc
  t=''                              /* reset token variable           */
  Return

lookback:
/***********************************************************************
* Look back if...
***********************************************************************/
  Do i_=ti To 1 By -1
    Select
      When left(t.i_.0t,1)='C' Then Nop
      When t.i_.0used<>1 &,
           (t.i_=g.0comma |,
            t.i_=g.0cont)  Then Do
        t.i_.0used=1
        t.i_=g.0cont
        Return '0'
        End
      Otherwise
        Return '1'
      End
    End
  Return '1'

isvar:
/***********************************************************************
* Determine if a string qualifies as variable name
***********************************************************************/
  Parse Arg a_ +1 b_
  res=(pos(a_,g.0a)>0) &,
    (verify(b_,g.0a||g.0n||'.')=0)
  Return res

isconst:
/***********************************************************************
* Determine if a string qualifies as constant
***********************************************************************/
  Parse Arg a_
  res=(verify(a_,g.0a||g.0n||'.+-')=0) /* ??? */
  Return res

setpos:
  Parse Arg seti sol soc
  setz='setpos:' t.seti t.seti.0ol'/'t.seti.0oc '-->',
                                                    sol'/'soc '('sigl')'
  Call dsp setz
  t.seti.0ol=sol
  t.seti.0oc=soc
  Return

process_tokens:
/***********************************************************************
* Process the token list
***********************************************************************/
  Do i=1 To t.0
    If g.0tokens Then
      Call lineout g.0tkf,right(i,4) right(t.i.0il,3)'.'left(t.i.0ic,3),
                                     right(t.i.0ol,3)'.'left(t.i.0oc,3),
                                     left(t.i.0t,2) left(t.i,25)
    If t.i='(' Then Do
      j=i-1
      If t.j.0ol=t.i.0il & ,
         t.j.0oc+length(t.j)=t.i.0ic &,
         pos(t.j.0t,'VS')>0 Then
        Call store_f t.j
      End
    End
  If g.0tokens Then
    Call lineout g.0tkf
  Return

store_f:
  Parse Arg funct
  If wordpos(funct,g.0fun_list)=0 then
    g.0fun_list=g.0fun_list funct
  cnt.funct=cnt.funct+1
  Return

dsp:
/***********************************************************************
* Record (and display) a debug line
***********************************************************************/
  Parse Arg ol_.1
  If g.0debug>0 Then
    Call lineout g.0dbg,ol_.1
  If g.0debug>1 Then
    Say ol_.1
  Return

wordsort: Procedure
/**********************************************************************
* Sort the list of words supplied as argument. Return the sorted list
**********************************************************************/
  Parse Arg wl
  wa.=''
  wa.0=0
  Do While wl<>''
    Parse Var wl w wl
    Do i=1 To wa.0
      If wa.i>w Then Leave
      End
    If i<=wa.0 Then Do
      Do j=wa.0 To i By -1
        ii=j+1
        wa.ii=wa.j
        End
      End
    wa.i=w
    wa.0=wa.0+1
    End
  swl=''
  Do i=1 To wa.0
    swl=swl wa.i
    End
  Return strip(swl)

err:
/***********************************************************************
* Diagnostic error exit
***********************************************************************/
  Parse Arg errnum, errtxt
  Say 'err:' errnum  errtxt
  If t.ti.0il>g.0il Then
    Say 'Error' arg(1) 'at end of file'
  Else Do
    Say 'Error' arg(1) 'around line' t.ti.0il', column' t.ti.0ic
    _=t.ti.0il
    Say l._
    Say copies(' ',t.ti.0ic-1)'|'
    End
  If errtxt<>'' Then Say '  'errtxt
  Exit 12
