/* REXX ---------------------------------------------------------------
* 10.01.2014 Walter Pachl  counts the number of possible ways
* 12.01.2014 corrected date and output
*--------------------------------------------------------------------*/
show=(arg(1)<>'')
blocks = 'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM'
list = '$ A baRk bOOk trEat coMMon squaD conFuse'
list=translate(list)
Do i=1 To words(blocks)
  blkn.i=word(blocks,i)'-'i
  blk.i=word(blocks,i)
  End
w.=''
wlen=0
Do i=1 To words(list)
  w.i=word(list,i)
  wlen=max(wlen,length(w.i))
  End
Do wi=0 To words(list)
  word = w.wi
  ways=0
  poss.=0
  lw=length(word)
  cannot=0
  Do i=1 To lw                         /* loop over the characters   */
    c=substr(word,i,1)                 /* the current character      */
    Do j=1 To words(blocks)            /* loop over blocks           */
      blk=word(blocks,j)
      If pos(c,blk)>0 Then Do  /* block can be used in this position */
        z=poss.i.0+1
        poss.i.z=j
        poss.i.0=z            /* number of possible blocks for pos i */
        End
      End
    If poss.i.0=0 Then Do
      cannot=1
      Leave i
      End
    End

  If cannot=0 Then Do                  /* no prohibitive character   */
    s.=0
    Do j=1 To poss.1.0          /* build possible strings for char 1 */
      z=s.1.0+1
      s.1.z=poss.1.j
      s.1.0=z
      End
    Do i=2 To lw          /* build possible strings for chars 1 to i */
      ii=i-1
      Do j=1 To poss.i.0
        Do k=1 To s.ii.0
          z=s.i.0+1
          s.i.z=s.ii.k poss.i.j
          s.i.0=z
          End
        End
      End
    Do p=1 To s.lw.0            /* loop through all possible strings */
      v=valid(s.lw.p)                  /* test if the string is valid*/
      If v Then Do                     /* it is                      */
        ways=ways+1                    /* increment number of ways   */
        way.ways=''                 /* and store the string's blocks */
        Do ii=1 To lw
          z=word(s.lw.p,ii)
          way.ways=way.ways blk.z
          End
        End
      End
    End
/*---------------------------------------------------------------------
* now show the result
*--------------------------------------------------------------------*/
  ol=left(''''word'''',wlen+2)
  Select
    When ways=0 Then
      ol=ol 'cannot be spelt'
    When ways=1 Then
      ol=ol 'can be spelt'
    Otherwise
      ol=ol 'can be spelt in' ways 'ways'
    End
  Say ol'.'
  If show Then Do
    Do wj=1 To ways
      Say copies(' ',10) way.wj
      End
    End
  End
Exit

valid: Procedure
/*---------------------------------------------------------------------
* Check if the same block is used more than once -> 0
* Else: the combination is valid
*--------------------------------------------------------------------*/
  Parse Arg list
  used.=0
  Do i=1 To words(list)
    w=word(list,i)
    If used.w Then Return 0
    used.w=1
    End
  Return 1
