/*REXX program displays  IPv4 and IPv6  addresses for a supplied  domain name.*/
trace off                              /*don't show PING none─zero return code*/
parse arg tar .                        /*obtain optional domain name from C.L.*/
if tar==''  then tar='www.kame.net'    /*Not specified?  Then use the default.*/
tempFID='\TEMP\DNSQUERY.$$$.'          /*define temp file to store the  IPv4. */
pingOpts='-l 0    -n 1    -w 1'   tar  /*define options for the PING command. */

  do j=4  to 6  by 2                   /*handle  IPv4  and  IPv6  addresses.  */
  'PING' (-j)  pingOpts  ">"  tempFID  /*restrict PING's output to a minimum. */
  q=charin(tempFID,1,999)              /*read the output file from  PING  cmd.*/
  parse var  q   '['   IPA   ']'       /*parse  IP  address from the output.  */
  say 'IPv'j 'for domain name  '  tar  "  is  "  IPA   /*IPv4 or IPv6 address.*/
  call lineout tempFID                 /* ◄──┬─◄  needed by some REXXes to    */
  end   /*j*/                          /*    └─◄         force file integrity.*/

'ERASE'  tempFID                       /*clean up (delete) the temporary file.*/
                                       /*stick a fork in it,  we're all done. */
