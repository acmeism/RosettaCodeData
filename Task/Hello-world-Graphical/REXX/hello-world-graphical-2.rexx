/*REXX pgm shows a "hello world" window (& another to show how to close)*/
parse upper version !ver .; !pcrexx='REXX/PERSONAL'==!ver |'REXX/PC'==!ver
if \!pcrexx then call ser "This isn't PC/REXX"        /* is ¬ PC/REXX ? */
rxWin=fcnpkg('rxwindow')                              /*function around?*/
if rxWin\==1 then do 1;     'RXWINDOW /q'
                  if fcnpkg('rxwindow')==1 then leave /*function is OK. */
                  say 'error loading RXWINDOW !';     exit 13
                  end
top=1;       normal=31;    border=30;   curpos=cursor()
width=40;    height=11;    line.=;      line.1='Goodbye, World!'
w=w_open(2,3,height+2,width,normal);    call w_border w,,,,,border
helpLine="press the  esc  key to quit"
helpw=w_open(2,50,3,length(helpLine)+4,normal)
call w_border helpw,,,,,border;  call w_put helpw,2,3,helpLine
call w_hide w, 'n'
                             do k=0  to height-1
                             _=top+k;  call w_put w,k+2,3,line._,width-4
                             end   /*k*/
call w_unhide w; esc='1b'x
                             do forever;  if inkey()=esc then leave;  end
call w_close w
call w_close helpw
if rxWin\==1  then 'RXUNLOAD rxwindow'
parse var curpos row col
call      cursor row, col
                                       /*stick a fork in it, we're done.*/
