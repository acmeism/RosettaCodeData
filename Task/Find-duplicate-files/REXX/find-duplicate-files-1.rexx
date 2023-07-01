/*REXX program to reads a (DOS) directory  and  finds and displays files that identical.*/
sep=center(' files are identical in size and content: ',79,"═")    /*define the header. */
tFID= 'c:\TEMP\FINDDUP.TMP'                      /*use this as a temporary  FileID.     */
arg maxSize aDir                                 /*obtain optional arguments from the CL*/
if maxSize='' | maxSize="," then maxSize=1000000 /*filesize limit (in bytes) [1 million]*/
aDir=strip(aDir)                                 /*remove any leading or trailing blanks*/
if right(aDir,1)\=='\'  then aDir=aDir"\"        /*possibly add a trailing backslash [\]*/
"DIR"  aDir  '/a-d-s-h /oS /s | FIND "/" >' tFID /*the (DOS) DIR output ───► temp file. */
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

if lines(tFID)\==0  then 'ERASE' tFID            /*do housecleaning  (delete temp file).*/
                                                 /*stick a fork in it,  we're all done. */
