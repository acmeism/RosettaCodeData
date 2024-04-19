/*REXX program validates user words against a  "command table"  with abbreviations.*/
Parse Arg userwords              /*obtain optional arguments from the command line */
If userwords='' Then             /* nothing specified, use default list from task  */
  userwords= 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'
Say 'user words: ' userwords
keyws='Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy',
      'COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find',
      'NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput',
      'Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO',
      'MErge MOve MODify MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT',
      'READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT',
      'RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up'
Say 'full words: ' validate(userwords)       /*display the result(s) To the terminal*/
Exit                                         /*stick a fork in it,  we're all Done. */
/*----------------------------------------------------------------------------------*/
validate: Procedure Expose keyws
  Arg userwords                 /* Arg = Parse Upper Arg get userwords in uppercase */
  res=''                        /* initialize the return string To null             */
  Do j=1 To words(userwords)    /* loop through userwords                           */
     uword=word(userwords,j)    /* get next userword                                */
     Do k=1 To words(keyws)     /* loop through all keywords                        */
       keyw=word(keyws,k)
       L=verify(keyw,'abcdefghijklmnopqrstuvwxyz','M') /* pos. of first lowercase ch*/
       If L==0 Then             /* keyword is all uppercase                         */
         L=length(keyw)         /* we need L characters for a match                 */
       Else
         L=L-1                  /* number of uppercase characters                   */
       If abbrev(translate(keyw),uword,L) Then Do  /* uword is an abbreviation      */
         res=res keyw           /* add the matching keyword To the result string    */
         iterate j              /* and proceed with the next userword if any        */
         End
       End
     res=res '*error*'          /* no match found. indicate error                   */
     End
   Return strip(res)            /* get rid of leading böank                         */
syntaxhighlight>
{{out|output|text=&nbsp; when using the default input:}}
<pre>
user words:  riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin
full words:  RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT
</pre>
