/*REXX prg displays a text string (in one direction), and reverses when a key is pressed*/
parse upper version !ver !vernum .;     !pcRexx= 'REXX/PERSONAL'==!ver  |  'REXX/PC'==!ver
if \!pcRexx  then do
                  say
                  say '***error***  This REXX program requires REXX/PERSONAL or REXX/PC.'
                  say
                  exit 1
                  end
parse arg $                                      /*obtain optional text message from CL.*/
if $=''  then $= 'Hello World!'                  /*Not specified?  Then use the default.*/
if right($, 1)\==' '  then $= $' '               /*ensure msg text has a trailing blank.*/
signal on halt                                   /*handle a HALT if user quits this way.*/
way = 0                                          /*default direction for marquee display*/
                  y =
        do  until y=='Q';  'CLS'                 /*if user presses  Q  or  q, then quit.*/
        call lineout ,$;   call delay .2         /*display output; delay 1/5 of a second*/
        y= inKey('Nowait');  upper y             /*maybe get a pressed key; uppercase it*/
        if y\==''  then way= \way                /*change the direction of the marquee. */
        if way  then $= substr($, 2)left($, 1)   /*display marquee in a direction or ···*/
                else $=  right($, 1)substr($, 1, length($) - 1)        /* ··· the other·*/
        end   /*until*/
halt:                                            /*stick a fork in it,  we're all done. */
