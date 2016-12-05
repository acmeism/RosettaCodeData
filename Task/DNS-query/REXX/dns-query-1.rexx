/*REXX program displays  IPV4 and IPV6  addresses for a supplied  domain name.*/
parse arg tar .                        /*obtain optional domain name from C.L.*/
if tar==''  then tar= 'www.kame.net'   /*Not specified?  Then use the default.*/
tFID    = '\TEMP\DNSQUERY.$$$'         /*define temp file to store IPV4 output*/
pingOpts= '-l 0    -n 1    -w 0'   tar /*define options for the PING command. */
trace off                              /*don't show PING none─zero return code*/
                                       /* [↓]  perform 2 versions of PING cmd.*/
  do j=4  to 6  by 2                   /*handle  IPV4  and  IPV6  addresses.  */
  'PING'  (-j)  pingOpts  ">"   tFID   /*restrict PING's output to a minimum. */
  q=charin(tFID, 1, 999)               /*read the output file from  PING  cmd.*/
  parse var  q   '['   ipaddr    "]"   /*parse  IP  address from the output.  */
  say 'IPV'j "for domain name  "  tar  '  is  '  ipaddr        /*IPVx address.*/
  call lineout tFID                    /* ◄──┬─◄  needed by some REXXes to    */
  end   /*j*/                          /*    └─◄  force (TEMP) file integrity.*/
                                       /*stick a fork in it,  we're all done. */
'ERASE'  tFID                          /*clean up (delete) the temporary file.*/
