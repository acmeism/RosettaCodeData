/*REXX program shows a "hello world" window (and another to show how to close)*/
parse upper version !ver .;     !pcrexx= !ver=='REXX/PERSONAL' | !ver=='REXX/PC'
if ¬!pcrexx  then call ser  "This isn't PC/REXX"     /*this isn't  PC/REXX ?  */
rxWin=fcnPkg('rxwindow')                             /*is the function around?*/

if rxWin¬==1  then do 1;     'RXWINDOW  /q'
                   if fcnPkg('rxwindow')==1 then leave   /*the function is OK.*/
                   say 'error loading RXWINDOW !';     exit 13
                   end

top=1;         normal=31;       border=30;   curpos=cursor()
width=40;      height=11;       line.=;      line.1= 'Goodbye, World!'
w=w_open(2, 3, height+2, width, normal);     call w_border  w,,,,,border
helpLine= 'press the  ESC  key to quit.'
helpW=w_open(2, 50, 3, length(helpLine)+4, normal)
call w_border helpw,,,,,border;  call w_put helpW, 2, 3, helpLine
call w_hide w, 'n'
                             do k=0  to height-1
                             _=top+k;      call w_put w, k+2, 3, line._, width-4
                             end   /*k*/
call w_unhide w
                             do forever;   if inKey()=='1b'x  then leave;  end
                                                   /*   ↑                     */
call w_close  w                                    /*   └──◄ the  ESCape  key.*/
call w_close  helpw
if rxWin¬==1  then 'RXUNLOAD rxwindow'
parse var curPos row  col
call      cursor row, col
                                       /*stick a fork in it,  we're all done. */
