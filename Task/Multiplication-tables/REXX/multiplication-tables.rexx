/*REXX program displays a  12x12  multiplication boxed grid table, grid */
/*         will be displayed in "boxing" characters for ASCII or EBCDIC.*/
parse arg high .                       /*get optional grid size.        */
if high=='' then high=12               /*not specified?  Use default.   */
ebcdic='f0'==1                         /*is this an EBCDIC machine?     */

if ebcdic then do                      /*══════════EBCDIC═══════════════*/
               bar='fa'x               /*vertical bar.                  */
               dash='bf'x              /*horizontal dash.               */
               bj ='cb'x               /*bottom junction.               */
               tj ='cc'x               /*   top junction.               */
               cj ='8f'x               /*center junction (cross).       */
               lj ='eb'x               /*  left junction.               */
               rj ='ec'x               /* right junction.               */
               tlc='ac'x               /*top     left corner.           */
               trc='bc'x               /*top    right corner.           */
               blc='ab'x               /*bottom  left corner.           */
               brc='bb'x               /*bottom right corner.           */
               end
          else do                      /*══════════ASCII════════════════*/
               bar='b3'x               /*vertical bar.                  */
               dash='c4'x              /*horizontal dash.               */
               bj ='c1'x               /*bottom junction.               */
               tj ='c2'x               /*   top junction.               */
               cj ='c5'x               /*center junction (cross).       */
               lj ='c3'x               /*  left junction.               */
               rj ='b4'x               /* right junction.               */
               tlc='da'x               /*top     left corner.           */
               trc='bf'x               /*top    right corner.           */
               blc='c0'x               /*bottom  left corner.           */
               brc='d9'x               /*bottom right corner.           */
               end

cell=cj || copies(dash,5)              /*define the top of the cell.    */
sep=copies(cell,high+1)rj              /*build the table separator.     */
sepL=length(sep)                       /*length of separator line.      */
width=length(cell)-1                   /*width of the table cells.      */
size=width-1                           /*width for table numbers.       */
box.=left('',width)                    /*construct all the cells.       */

  do j=0 to high                       /*step through zero to H (12).   */
  _=right(j,size-1)'x '                /*build "label"/border number.   */
  box.0.j=_                            /*build  top label cell.         */
  box.j.0=_                            /*build left label cell.         */
  end   /*j*/

box.0.0=centre('times',width)          /*redefine  box.0.0  with  'X'.  */

     do   row=1   for high             /*step through  1  to H (12).    */
       do col=row  to high             /*step through row to H (12).    */
       box.row.col=right(row*col,size)' '         /*build a mult. cell. */
       end    /*col*/
     end      /*row*/

  do row=0 to high                     /*step through all the lines.    */
  asep=sep                             /*allow use of a modified sep.   */
  if row==0 then do
                 asep=overlay(tlc,asep,1)       /*make a better tlc.    */
                 asep=overlay(trc,asep,sepL)    /*make a better trc.    */
                 asep=translate(asep,tj,cj)     /*make a better  tj.    */
                 end
            else asep=overlay(lj,asep,1)        /*make a better  lj.    */

  say asep                             /*display a table grid line.     */
  if row==0 then call buildLine 00     /*display a blank grid line.     */
                 call buildLine row    /*build one line of the grid.    */
  if row==0 then call buildLine 00     /*display a blank grid line.     */
  end   /*row*/

asep=sep                               /*allow use of a modified sep.   */
asep=overlay(blc,asep,1)               /*make a better bot  left corner.*/
asep=overlay(brc,asep,sepL)            /*make a better bot right corner.*/
asep=translate(asep,bj,cj)             /*make a better bot junction.    */
say asep                               /*display a table grid line.     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUILDLINE subroutine────────────────*/
buildLine: w=;   parse arg arow        /*start with a blank cell.       */

               do col=0  to high       /*step through  0  to  H (12).   */
               w=w||bar||box.arow.col  /*build one cell at a time.      */
               end   /*col*/
say w || bar                           /*finish building the last cell. */
return
