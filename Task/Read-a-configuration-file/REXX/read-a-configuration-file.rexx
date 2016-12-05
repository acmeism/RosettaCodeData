/*REXX program reads a config (configuration) file and assigns  VARs  as found within.  */
signal on syntax;      signal on novalue         /*handle REXX source program errors.   */
parse arg cFID _ .                               /*cFID:  is the CONFIG file to be read.*/
if cFID==''  then cFID='CONFIG.DAT'              /*Not specified?  Then use the default.*/
bad=                                             /*this will contain all the  bad VARs. */
varList=                                         /*  "    "     "     "   "  good   "   */
maxLenV=0;   blanks=0;   hashes=0;   semics=0;   badVar=0    /*zero all these variables.*/

   do j=0  while lines(cFID)\==0                 /*J:   it counts the lines in the file.*/
   txt=strip(linein(cFID))                       /*read a line (record) from the file,  */
                                                 /*  ··· & strip leading/trailing blanks*/
   if      txt    =''    then do; blanks=blanks+1; iterate; end   /*count # blank lines.*/
   if left(txt,1)=='#'   then do; hashes=hashes+1; iterate; end   /*  "   " lines with #*/
   if left(txt,1)==';'   then do; semics=semics+1; iterate; end   /*  "   "   "     "  ;*/
   eqS=pos('=',txt)                              /*we can't use the   TRANSLATE   BIF.  */
   if eqS\==0  then txt=overlay(' ',txt,eqS)     /*replace the first  '='  with a blank.*/
   parse var txt xxx value;  upper xxx           /*get the variable name and it's value.*/
   value=strip(value)                            /*strip leading and trailing blanks.   */
   if value='' then value='true'                 /*if no value,  then use   "true".     */
   if symbol(xxx)=='BAD'  then do                /*can REXX utilize the variable name ? */
                               badVar=badVar+1;  bad=bad xxx;  iterate  /*append to list*/
                               end
   varList=varList xxx                           /*add it to the list of good variables.*/
   call value xxx,value                          /*now,  use VALUE to set the variable. */
   maxLenV=max(maxLenV,length(value))            /*maxLen of varNames,  pretty display. */
   end   /*j*/

vars=words(varList);          @ig= 'ignored that began with a'
                    say #(j)       'record's(j) "were read from file: " cFID
if blanks\==0  then say #(blanks)  'blank record's(blanks) "were read."
if hashes\==0  then say #(hashes)  'record's(hashes)   @ig   "#  (hash)."
if semics\==0  then say #(semics)  'record's(semics)   @ig   ";  (semicolon)."
if badVar\==0  then say #(badVar)  'bad variable name's(badVar) 'detected:' bad
say;  say 'The list of'    vars    "variable"s(vars)    'and'    s(vars,'their',"it's"),
                                   "value"s(vars)       'follows:'
say;          do k=1  for vars
              v=word(varList,k)
              say  right(v,maxLenV) '=' value(v)
              end   /*k*/
say;  exit                                       /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:       if arg(1)==1  then return arg(3);               return word(arg(2) 's',1)
#:       return right(arg(1),length(j)+11)       /*right justify a number & also indent.*/
err:       do j=1  for arg();  say '***error***    ' arg(j);  say;  end  /*j*/;    exit 13
novalue: syntax:   call err 'REXX program' condition('C') "error",,
         condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
