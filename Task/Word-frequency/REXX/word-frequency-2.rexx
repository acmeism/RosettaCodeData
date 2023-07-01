/*REXX program   reads  and  displays  a  count  of words a file.  Word case is ignored.*/
Call time 'R'
abc='abcdefghijklmnopqrstuvwxyz'
abcABC=abc||translate(abc)
parse arg fID_top                                /*obtain optional arguments from the CL*/
Parse Var fid_top fid ',' top
if fID=='' then fID= 'mis.TXT'                   /* Use default if not specified        */
if top=='' then top= 10                          /* Use default if not specified        */
occ.=0                                           /* occurrences of word (stem) in file  */
wn=0
Do While lines(fid)>0                            /*loop whilst there are lines in file. */
  line=linein(fID)
  line=translate(line,abc||abc,abcABC||xrange('00'x,'ff'x)) /*use only lowercase letters*/
  Do While line<>''
    Parse Var line word line                       /* take a word                         */
    If occ.word=0 Then Do                          /* not yet in word list                */
      wn=wn+1
      word.wn=word
      End
    occ.word=occ.word+1
    End
  End
Say 'We found' wn 'different words'
say right('word',40) ' rank   count '            /* header                              */
say right('----',40) '------ -------'            /* separator.                          */
tops=0
Do Until tops>=top | tops>=wn                    /*process enough words to satisfy  TOP.*/
  max_occ=0
  tl=''                                          /*initialize (possibly) a list of words*/
  Do wi=1 To wn                                  /*process the list of words in the file*/
    word=word.wi                                 /* take a word from the list           */
    Select
      When occ.word>max_occ Then Do              /* most occurrences so far             */
        tl=word                                  /* candidate for output                */
        max_occ=occ.word                         /* current maximum occurrences         */
        End
      When occ.word=max_occ Then Do              /* tied                                */
        tl=tl word                               /* add to output candidate             */
        End
      Otherwise                                  /* no candidate (yet)                  */
        Nop
      End
    End
    do d=1 for words(tl)
      word=word(tl,d)
      say right(word,40) right(tops+1,4) right(occ.word,8)
      occ.word=0                                /*nullify this word count for next time*/
      End
    tops=tops+words(tl)                         /*correctly handle the tied rankings.  */
  end
Say time('E') 'seconds elapsed'
