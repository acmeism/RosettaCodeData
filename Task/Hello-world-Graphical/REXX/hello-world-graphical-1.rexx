/*REXX (using PC/REXX)  to display a message in a window (which is bordered). */
if fcnPkg('rxWindow') ¬== 1  then do
                                  say 'RXWINDOW function package not loaded.'
                                  exit 13
                                  end
if pcVideo()==3  then normal= 7
                 else normal=13

window#=w_open(1, 1, 3, 80, normal)
call w_border  window#
call w_put     window#, 2, 2, center("Goodbye, World!", 80-2)

                                       /*stick a fork in it, all we're done. */
