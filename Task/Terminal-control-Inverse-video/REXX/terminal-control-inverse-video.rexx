/*REXX program to demonstrate reverse video.                            */
@day   = 'day'
@night = 'night'
call scrwrite , 1, @day, , , 7                         /*white on black.*/
call scrwrite , 1+length(@day), @night, , , 112        /*black on white.*/
                                       /*stick a fork in it, we're done.*/
