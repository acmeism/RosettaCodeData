/* REXX ---------------------------------------------------------------
* Create a list of Rosetta Code languages showing the number of tasks
* This program's logic is basically that of the REXX program
* rearranged to my taste and utilizing the array class of ooRexx
* which offers a neat way of sorting as desired, see :CLASS mycmp below
* For the input to this program open these links:
*  http://rosettacode.org/wiki/Category:Programming_Languages
*  http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000
* and save the pages as LAN.txt and CAT.txt, respectively
* Output: RC_POP.txt list of languages sorted by popularity
* If test=1, additionally:
*         RC_LNG.txt list of languages alphabetically sorted
*         RC_TRN.txt list language name translations (debug)
*--------------------------------------------------------------------*/
test=1
name.='??'
l.=0
safe=''
x00='00'x
linfid='RC_LAN.txt'
linfid='LAN.txt'                       /* language file              */
cinfid='CAT.txt'                       /* category file              */
oid='RC_POP.txt'; 'erase' oid
If test Then Do
  tid='RC.TRN.txt'; 'erase' tid
  tia='RC_LNG.txt'; 'erase' tia
  End
Call init

call read_lang                         /* process language file      */

Call read_cat                          /* process category file      */

Call ot words(lang_list) 'possible languages'
Call ot words(lang_listr) 'relevant languages'
llrn=words(lang_listr)

If test Then
  Call no_member

a=.array~new                           /* create array object        */
cnt.=0
Do i=1 By 1 While lang_listr<>''
  Parse Var lang_listr ddu0 lang_listr
  ddu=translate(ddu0,' ',x00)
  a[i]=right(mem.ddu,3) name.ddu       /* fill array element         */
  z=mem.ddu                            /* number of members          */
  cnt.z=cnt.z+1                        /* number of such languages   */
  End
n=i-1                                  /* number of output lines     */

a~sortWith(.mycmp~new)                 /* sort the array elements    */
                                       /* see :CLASS mycmp below     */
/*---------------------------------------------------------------------
* and now create the output
*--------------------------------------------------------------------*/
Call o ' '
Call o center('timestamp: ' date() time('Civil'),79,'-')
Call o ' '
Call o right(lrecs,9) 'records read from file: ' linfid
Call o right(crecs,9) 'records read from file: ' cinfid
Call o right(llrn,9) 'relevant languages'
Call o ' '

rank=0
rank.=0
Do i=1 To n
  rank=rank+1
  Parse Value a[i] With o . 6 lang
  ol='          rank: 'right(rank,3)'               '||,
                    '('right(o,3) 'entries)  'lang
  If cnt.o>1 Then Do
    If rank.o=0 Then
      rank.o=rank
    ol=overlay(right(rank.o,3),ol,17)
    ol=overlay('[tied]',ol,22)
    End
  Call o ol
  End

Call o ' '
Call o center('+ end of list +',72)
Say 'Output in' oid

If test Then Do
  b=.array~new                         /* create array object        */
  cnt.=0
  Do i=1 By 1 While lang_list<>''
    Parse Var lang_list ddu0 lang_list
    ddu=translate(ddu0,' ',x00)
    b[i]=right(mem.ddu,3) name.ddu       /* fill array element         */
    End
  n=i-1                                  /* number of output lines     */

  b~sortWith(.alpha~new)               /* sort the array elements    */
  Call oa n 'languages'
  Do i=1 To n
    Call oa b[i]
    End
  Say 'Sorted list of languages in' tia
  End
Exit

o:
  Return lineout(oid,arg(1))
ot:
  If test Then Call lineout tid,arg(1)
  Return
oa:
  If test Then Call lineout tia,arg(1)
  Return

read_lang:
/*---------------------------------------------------------------------
* Read the language page to determine the list of possible languages
* Output: l.lang>0  for all languages found
*         name.lang original name of uppercased language name
*         lang_list list of uppercased language names
*         lrecs     number of records read from language file
*--------------------------------------------------------------------*/
  l.=0
  name.='??'
  lang_list=''
  Do lrecs=0 While lines(linfid)\==0
    l=linein(linfid)                   /* read from language file    */
    l=translate(l,' ','9'x)            /* turn tabs to blanks        */
    dd=space(l)                        /* remove extra blanks        */
    ddu=translate(dd)
    If pos('AUTOMATED ADMINISTRATION',ddu)>0 Then /* ignore this     */
      Iterate
    If pos('RETRIEVED FROM',ddu)\==0 Then /* this indicates the end  */
      Leave
    If dd=='' Then                     /* ignore all blank lines.    */
      Iterate
    If left(dd,1)\=='*' Then           /* ignore lines w/o *         */
      Iterate
    ddo=fix_lang(dd)                   /* replace odd language names */
    If ddo<>dd Then Do                 /* show those that we found   */
      Call ot ' ' dd
      Call ot '>' ddo
      dd=ddo
      End
    Parse Var dd '*' dd "<"            /* extract the language name  */
    ddu=strip(translate(dd))           /* translate to uppercase     */
    If name.ddu='??' Then
      name.ddu=dd                      /* remember 1st original name */
    l.ddu=l.ddu+1
    ddu_=translate(ddu,x00,' ')
    If wordpos(ddu_,lang_list)=0 Then
      lang_list=lang_list ddu_
    End
  Return

read_cat:
/*---------------------------------------------------------------------
* Read the category page to get language names and number of members
* Output: mem.ddu   number of members for (uppercase) Language ddu
*         lang_listr  the list of relevant languages
*--------------------------------------------------------------------*/
  mem.=0
  lang_listr=''
  Do crecs=0 While lines(cinfid)\==0
    l=get_cat(cinfid)                  /* read from category file    */
    l=translate(l,' ','9'x)            /* turn tabs to blanks        */
    dd=space(l)                        /* remove extra blanks        */
    If dd=='' Then                     /* ignore all blank lines.    */
      Iterate
    ddu=translate(dd)
    ddo=fix_lang(dd)                   /* replace odd language names */
    If ddo<>dd Then Do                 /* show those that we found   */
      Call ot ' ' dd
      Call ot '>' ddo
      dd=ddo
      End
    du=translate(dd)                   /* get an uppercase version.  */
    If pos('RETRIEVED FROM',du)\==0 Then  /* this indicates the end  */
      Leave
    Parse Var dd dd '<' "(" mems .     /* extract the language name  */
                                       /* and the number of members  */
    dd=space(substr(dd,3))
    _=translate(dd)
    If \l._ Then                       /* not a known language       */
      Iterate                          /* ignore                     */
    if pos(',', mems)\==0  then
      mems=changestr(",", mems, '')    /* remove commas.             */
    If\datatype(mems,'W') Then         /* not a number of members    */
      Iterate                          /* ignore                     */
    ddu=space(translate(dd))
    mem.ddu=mem.ddu+mems               /* set o add number of members*/
    Call memory ddu                    /* list of relevant languages */
    End
  Return

get_cat:
/*---------------------------------------------------------------------
* get a (logical) line from the category file
* These two lines
*   * Lotus 123 Macro Scripting
*     </wiki/Category:Lotus_123_Macro_Scripting>â€�â€Ž (3 members)
* are returned as one line:
*-> * Lotus 123 Macro Scripting     </wiki/Cate  ... (3 members)
* we need language name and number of members in one line
*--------------------------------------------------------------------*/
  Parse Arg fid
  If safe<>'' Then
    ol=safe
  Else Do
    If lines(fid)=0 Then
      Return ''
    ol=linein(fid)
    safe=''
    End
  If left(ol,3)='  *' Then Do
    Do Until left(r,3)=='  *' | lines(fid)=0
      r=linein(fid)
      If left(r,3)=='  *' Then Do
        safe=r
        Return ol
        End
      Else
        ol=ol r
      End
    End
  Return ol

memory:
  ddu0=translate(ddu,x00,' ')
  If wordpos(ddu0,lang_listr)=0 Then
    lang_listr=lang_listr ddu0
  Return

fix_lang: Procedure Expose old. new.
  Parse Arg s
  Do k=1 While old.k\==''         /* translate Unicode variations.  */
    If pos(old.k,s)\==0 Then
      s=changestr(old.k,s,new.k)
    End
  Return s

init:
  old.=''
  old.1='UC++'        /* '55432B2B'X                                 */
  new.1="µC++"        /* old      UC++ --?ASCII-8: µC++              */
  old.2='ÐœÐš-61/52'  /* 'D09CD09A2D36312F3532'X                     */
  new.2='MK-61/52'    /* somewhere a mistranslated: MK-              */
  old.3='DÃ©jÃ  Vu'   /* '44C3A96AC3A0205675'X                       */
  new.3='Déjà Vu'     /* Unicode +¬j+á --?ASCII-8: Déjá              */
  old.4='CachÃ©'      /* '43616368C3A9'X                             */
  new.4='Caché'       /* Unicode ach+¬ --?ASCII-8: Caché             */
  old.5='ÎœC++'       /* 'CE9C432B2B'X                               */
  new.5="MC++"        /* Unicode +£C++ --?ASCII-8: µC++              */
  /*-----------------------------------------------------------------*/
  Call ot 'Language replacements:'
  Do ii=1 To 5
    Call ot ' ' left(old.ii,10) left(c2x(old.ii),20) '->' new.ii
    End
  Call ot ' '
  Return

no_member: Procedure Expose lang_list lang_listr tid x00 test
/*---------------------------------------------------------------------
* show languages found in language file that are not referred to
* in the category file
*--------------------------------------------------------------------*/
  ll =wordsort(lang_list )             /* languages in language file */
  llr=wordsort(lang_listr)             /* languages in category file */
  Parse Var ll l1 ll
  Parse Var llr l2 llr
  nn.=0
  Do Forever
    Select
      When l1=l2 Then Do
        If l1='' Then                  /* both lists empty           */
          Leave
        Parse Var ll l1 ll             /* get the next language      */
        Parse Var llr l2 llr           /* -"-                        */
        End
      When l1<l2 Then Do               /* in language file           */
                                       /* and not in category file   */
        z=nn.0+1
        nn.z='   'translate(l1,' ',x00) /* show in test output       */
        nn.0=z
        Parse Var ll l1 ll             /* next from language file    */
        End
      Otherwise Do
        Call ot '?? 'translate(l2,' ',x00) /* show in test output    */
        Say 'In category file but not in language file:'
        Say '?? 'translate(l2,' ',x00)
        Say 'Hit enter to proceed'
        Pull .
        Parse Var llr l2 llr           /* next from category file    */
        End
      End
    End
  Call ot nn.0 'Languages without members:' /* heading                    */
  Do ii=1 To nn.0
    Call ot nn.ii
    End
  Return

::CLASS mycmp MIXINCLASS Comparator
::METHOD compare
/**********************************************************************
* smaller number is considered higher
* numbers equal: higher language considered higher
* otherwise return lower
**********************************************************************/
  Parse Upper Arg a,b
  Parse Var a na +4 ta
  Parse Var b nb +4 tb
  Select
    When na<<nb THEN res=1
    When na==nb Then Do
      If ta<<tb Then res=-1
                Else res=1
      End
    Otherwise        res=-1
    End
  Return res


::CLASS alpha MIXINCLASS Comparator
::METHOD compare
/**********************************************************************
* higher language considered higher
* otherwise return lower
**********************************************************************/
  Parse Upper Arg a,b
  Parse Var a na +4 ta
  Parse Var b nb +4 tb
  If ta<<tb Then res=-1
            Else res=1
  Return res
