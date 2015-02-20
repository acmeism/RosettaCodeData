/*REXX pgm displays  IPv4 and IPv6 addresses for a supplied domain name.*/
trace off                              /*don't show the PING return code*/
parse arg dn .                         /*get the optional domain name.  */
if dn==''  then dn = 'www.kame.net'    /*Not specified? Then use default*/
tmp = '\TEMP\TEMP.PING'                /*define temp file to store IPv4.*/

  do j=4  to 6  by 2                   /*handle IPv4 and IPv6 addresses.*/
  'PING' (-j)  '-l 0 -n 1' dn ">"  tmp /*restrict PING's output to min. */
  q=charin(tmp,1,999)                  /*read output file from PING cmd.*/
  parse var  q   '['   IPA   ']'       /*parse  IP a ddress from output.*/
  say 'IPv'j 'for domain name  ' dn "  is  " IPA     /*IPv4 | IPv6 addr.*/
  call lineout tmp                     /*needed by most REXXes to ···   */
  end   /*j*/                          /* [↑]  ··· force file integrity.*/

'ERASE'  tmp                           /*clean up the temporary file.   */
                                       /*stick a fork in it, we're done.*/
