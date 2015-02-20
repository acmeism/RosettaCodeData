/*REXX program to create an  HTML table  of five rows and three columns.*/
arg rows .;  if rows==''  then rows=5  /*no ROWS specified?  Use default*/
      cols = 3                         /*specify three columns for table*/
   maxRand = 9999                      /*4-digit numbers, allow negative*/
headerInfo = 'X Y Z'                   /*column header information.     */
      oFID = 'a_table.html'            /*name of the  output file.      */
         w = 0                         /*number of writes to output file*/

call wrt  "<html>"
call wrt  "<head></head>"
call wrt  "<body>"
call wrt  "<table border=5  cellpadding=20  cellspace=0>"

  do r=0  to rows                      /* [↓]  handle row zero special. */
  if r==0  then call wrt  "<tr><th></th>"
           else call wrt  "<tr><th>"   r   "</th>"

      do c=1  for cols                 /* [↓]  for row zero, add hdrInfo*/
      if r==0  then call wrt  "<th>" word(headerInfo,c) "</th>"
               else call wrt  "<td align=right>"  rnd() "</td>"
      end   /*c*/
  end       /*r*/

call wrt  "</table>"
call wrt  "</body>"
call wrt  "</html>"
say;         say  w    ' records were written to the output file: '   oFID
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one-liner subroutines───────────────*/
rnd: return right(random(0,maxRand*2)-maxRand,5) /*REXX doesn't gen negs*/
wrt: call lineout oFID,arg(1); say '══►' arg(1); w=w+1; return  /*write.*/
        /* [↑]  functions were subroutinized for better viewabilityness.*/
