/*REXX program validates a user  "word"  against a  "command table"  with abbreviations.*/
parse arg uw                                     /*obtain optional arguments from the CL*/
if uw=''  then uw= 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'
say 'user words: '   uw

@= 'Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy'   ,
   'COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find'   ,
   'NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput'   ,
   'Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO'   ,
   'MErge MOve MODify MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT'   ,
   'READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT'   ,
   'RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up'

say 'full words: '   validate(uw)                /*display the result(s) to the terminal*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
validate: procedure expose @;  arg x;  upper @   /*ARG   capitalizes all the  X  words. */
          $=                                     /*initialize the return string to null.*/
             do j=1  to words(x);   _=word(x, j) /*obtain a word from the     X  list.  */
               do k=1  to words(@); a=word(@, k) /*get a legitimate command name from @.*/
               L=verify(_, 'abcdefghijklmnopqrstuvwxyz', "M")  /*maybe get abbrev's len.*/
               if L==0  then L=length(_)         /*0?  Command name can't be abbreviated*/
               if abbrev(a, _, L)   then do; $=$ a;  iterate j;  end  /*is valid abbrev?*/
               end   /*k*/
             $=$ '*error*'                       /*processed the whole list, not valid. */
             end     /*j*/
          return strip($)                        /*elide the superfluous leading blank. */
