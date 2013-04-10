/*REXX program to create an HTML table of five rows and three columns.  */

arg rows .; if rows=='' then rows=5    /*no ROWS specified?  Use default*/
      cols=3
   maxRand=9999                        /*4-digit numbers, allow negative*/
headerInfo='X Y Z'                     /*column header information.     */
      oFID='a_table.html'

call lineout oFid,"<html>"
call lineout oFid,"<head></head>"
call lineout oFid,"<body>"
call lineout oFid,"<table border=5  cellpadding=20  cellspace=0>"

  do r=0 to rows
  if r==0 then call lineout oFid,"<tr><th></th>"
          else call lineout oFid,"<tr><th>"   r   "</th>"

      do c=1 for cols
      if r==0 then call lineout oFid,"<th>" word(headerInfo,c) "</th>"
              else call lineout oFid,"<td align=right>"  rnd() "</td>"
      end   /*c*/

  end        /*r*/

call lineout oFid,"</table>"
call lineout oFid,"</body>"
call lineout oFid,"</html>"
exit

/*─────────────────────────────────────RND subroutine───────────────────*/
           /*subroutine was subroutinized for better viewfulabilityness.*/
rnd: return right(random(0,maxRand*2)-maxRand,5) /*REXX doesn't gen negs*/
