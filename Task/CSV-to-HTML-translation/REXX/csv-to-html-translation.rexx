/*REXX program to convert CSV ───► HTML table representing the CSV data.*/
arg header_ .                          /*see if the user wants a header.*/
wantsHdr= (header_=='HEADER')          /*arg (low/upp/mix case)=HEADER ?*/

                  iFID= 'CSV_HTML.TXT' /*the   input  fileID.           */
if wantsHdr  then oFID= 'OUTPUTH.HTML' /*output fileID with    header,  */
             else oFID= 'OUTPUT.HTML'  /*   "      "   without header.  */

    do rows=0  while  lines(iFID)\==0  /*read the rows from a (txt) file*/
    row.rows=strip(linein(iFID))
    end   /*rows*/

convFrom= '&     <    >    "'          /*special characters to convert. */
convTo  = '&amp; &lt; &gt; &quot;'     /*what they are converted into.  */

call write , '<html>'
call write , '<table border=4 cellpadding=9 cellspacing=1>'

  do j=0 for rows;                     call write 5, '<tr>'
                           tx='td'
  if wantsHdr & j==0  then tx='th'

       do  while  row.j\=='';          parse var row.j yyy ',' row.j
           do k=1  for words(convFrom)
           yyy=changestr(word(convFrom,k),yyy,word(convTo,k))
           end   /*k*/
       call write 10, '<'tx">"yyy'</'tx">"
       end       /*forever*/
  end            /*j*/

call write 5, '<tr>'
call write  , '</table>'
call write  , '</html>'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────WRITE subroutine────────────────────*/
write:   call lineout oFID, left('', 0 || arg(1))arg(2);            return
