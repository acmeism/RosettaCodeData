/*REXX program to read a config file and assign VARs as found within.   */
signal on syntax; signal on novalue    /*handle REXX program errors.    */
parse arg cFID _ .                     /*cFID = config file to be read. */
if cFID==''  then cFID='CONFIG.DAT'    /*Not specified?  Use the default*/
bad=                                   /*this will contain all bad VARs.*/
varList=                               /*this will contain all the VARs.*/
maxLenV=0;   blanks=0;   hashes=0;   semics=0;   badVar=0    /*zero 'em.*/

   do j=0  while lines(cFID)\==0       /*J count's the file's lines.    */
   txt=strip(linein(cFID))             /*read a line (record) from file,*/
                                       /*& strip leading/trailing blanks*/
   if txt         =''    then do; blanks=blanks+1; iterate; end
   if left(txt,1)=='#'   then do; hashes=hashes+1; iterate; end
   if left(txt,1)==';'   then do; semics=semics+1; iterate; end
   eqS=pos('=',txt)                    /*can't use the  TRANSLATE  bif. */
   if eqS\==0 then txt=overlay(' ',txt,eqS) /*replace 1st '=' with blank*/
   parse var txt xxx value;  upper xxx /*get the variableName and value.*/
   value=strip(value)                  /*strip leading & trailing blanks*/
   if value='' then value='true'       /*if no value, then use "true".  */
   if symbol(xxx)=='BAD'  then do      /*can REXX use the variable name?*/
                               badVar=badVar+1;    bad=bad xxx;    iterate
                               end
   varList=varList xxx                 /*add it to the list of variables*/
   call value xxx,value                /*now, use VALUE to set the var. */
   maxLenV=max(maxLenV,length(value))  /*maxLen of varNames, pretty disp*/
   end   /*j*/

vars=words(varList)
                   say #(j)      'record's(j) "were read from file: " cFID
if blanks\==0 then say #(blanks) 'blank record's(blanks) "were read."
if hashes\==0 then say #(hashes) 'record's(hashes) "ignored that began with a # (hash)."
if semics\==0 then say #(semics) 'record's(semics) "ignored that began with a ; (semicolon)."
if badVar\==0 then say #(badVar) 'bad variable name's(badVar) 'detected:' bad
say; say 'The list of' vars "variable"s(vars) 'and' s(vars,'their',"it's") "value"s(vars) 'follows:'; say

              do k=1  for vars
              v=word(varList,k)
              say  right(v,maxLenV) '=' value(v)
              end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────error handling subroutines and others.─*/
s: if arg(1)==1  then return arg(3);    return word(arg(2) 's',1)
#: return right(arg(1),length(j)+11)    /*right justify a number +indent*/
err: say;  say;  say  center(' error! ', max(40, linesize()%2), "*");  say
                do j=1  for arg();  say arg(j);  say;  end;  say;  exit 13
novalue: syntax:   call err 'REXX program' condition('C') "error",,
         condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
