/*REXX program to reads a (DOS) directory  and  finds and displays files that identical.*/
sep=center(' files are identical in size and content: ',79,"═")    /*define the header. */
parse arg !;     if !all(arg())  then exit                         /*boilerplate HELP(?)*/
signal on halt;  signal on novalue;  signal on syntax              /*handle exceptions, */

if \!dos  then call err 'this program requires the DOS [environment].'
call getTFID                                     /*defines a temporary  File ID for DOS.*/
arg maxSize aDir                                 /*obtain optional arguments from the CL*/
if maxSize='' | maxSize="," then maxSize=1000000 /*filesize limit (in bytes) [1 million]*/
if \isInt(maxSize)      then call err  "maxSize isn't an integer:"       maxSize
if maxSize<0            then call err  "maxSize can't be negative:"      maxSize
if maxSize=0            then call err  "maxSize can't be zero:"          maxSize
aDir=strip(aDir)                                 /*remove any leading or trailing blanks*/
if right(aDir,3)=='*.*' then aDir=substr(aDir,1,length(aDir)-3)   /*adjust the dir name.*/
if right(aDir,1)\=='\'  then aDir=aDir"\"        /*possibly add a trailing backslash [\]*/
@dir    = 'DIR'                                  /*literal for the (DOS)  DIR  command. */
@dirNots= '/a-d-s-h'                             /*ignore DIRs, SYSTEM, and HIDDEN files*/
@dirOpts= '/oS /s'                               /*sort DIR's (+ subdirs) files by size.*/
@filter = '| FIND "/"'                           /*the "lines" must have a slash [/].   */
@erase  = 'ERASE'                                /*literal for the (DOS)  ERASE command.*/
@dir aDir @dirNots @dirOpts @filter '>' tFID     /*(DOS) DIR  output ──► temporary file.*/
pFN=                                             /*the previous  filename and filesize. */
pSZ=;  do j=0  while lines(tFID)\==0             /*process each of the files in the list*/
       aLine=linein(tFID)                        /*obtain (DOS) DIR's output about a FID*/
       parse var aLine . . sz fn                 /*obtain the filesize and its fileID.  */
       sz=space(translate(sz,,','),0)            /*elide any commas from the size number*/
       if sz>maxSize  then leave                 /*Is the file > maximum?  Ignore file. */
                                                 /* [↓]  files identical?  (1st million)*/
       if sz==pSZ  then  if charin(aDir||pFN,1,sz)==charin(aDir||FN,1,sz)  then do
                                                                                say sep
                                                                                say pLine
                                                                                say aLine
                                                                                say
                                                                                end
       pSZ=sz;      pFN=FN;      pLine=aLine     /*remember the previous stuff for later*/
       end   /*j*/

say j  'file's(j)  "examined in"  aDir           /*show information to the screen.*/
if lines(tFID)\==0  then 'ERASE'  tFID           /*do housecleaning  (delete temp file).*/
exit                                             /*stick a fork in it,  we're all done. */
/*═════════════════════════════general 1─line subs══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
!all:  !!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=="NT";!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,"? ?SAMPLES ?AUTHOR ?FLOW")==0 then return 0;!call=']$H';call "$H" !fn !;!call=;return 1
!cal:  if symbol('!CALL')\=="VAR" then !call=; return !call
!env:  !env='ENVIRONMENT'; if !sys=="MSDOS" | !brexx | !r4 | !roo  then !env='SYSTEM'; if !os2  then !env="OS2"!env; !ebcdic=1=='f1'x;     return
!fid:  parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .; call !sys; if !dos  then do; _=lastpos('\',!fn); !fm=left(!fn,_); !fn=substr(!fn,_+1); parse var !fn !fn "." !ft; end;     return word(0 !fn !ft !fm, 1+('0'arg(1)))
!rex:  parse upper version !ver !vernum !verdate .; !brexx='BY'==!vernum; !kexx="KEXX"==!ver; !pcrexx='REXX/PERSONAL'==!ver | "REXX/PC"==!ver; !r4='REXX-R4'==!ver; !regina="REXX-REGINA"==left(!ver,11); !roo='REXX-ROO'==!ver; call !env;   return
!sys:  !cms=!sys=='CMS'; !os2=!sys=="OS2"; !tso=!sys=='TSO' | !sys=="MVS"; !vse=!sys=='VSE'; !dos=pos("DOS",!sys)\==0|pos('WIN',!sys)\==0|!sys=="CMD"; call !rex;                          return
!var:  call !fid; if !kexx  then return space(dosenv(arg(1)));             return space(value(arg(1),,!env))
err:       say;  say;  say  center(' error! ', 60, "*");  say;  do j=1  for arg();  say arg(j);  say;  end;  say;  exit 13
getdTFID:  tfid=p(!var("TMP") !var('TEMP') homedrive()"\"); if substr(tfid,2,1)==':'&substr(tfid,3,1)\=="\" then tfid=insert('\',t,2);        return strip(tfid,"T",'\')"\"arg(1)'.'arg(2)
getTFID:   if symbol('TFID')=="LIT" then tfid=; if tfid\=='' then return tfid; gfn=word(arg(1) !fn,1);gft=word(arg(2) "TMP",1); tfid='TEMP';if !tso  then tfid=gfn"."gft;if !cms  then tfid=gfn','gft",A4";if !dos then tfid=getdTFID(gfn,gft);return tfid
halt:      call err 'program has been halted.'
homedrive: if symbol('HOMEDRIVE')\=="VAR"  then homedrive=p(!var('HOMEDRIVE') "C:");   return homedrive
isint:     return datatype(arg(1),'W')
novalue:   syntax:   call err 'REXX program' condition("C") 'error',condition("D"),'REXX source statement (line' sigl"):",sourceline(sigl)
p:         return word(arg(1),1)
s:         if arg(1)==1  then return arg(3);   return word(arg(2) 's',1)
