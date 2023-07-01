/*REXX pgm shows a network device's manufacturer based on the Media Access Control addr.*/
win_command         = 'getmac'                   /*name of the Microsoft Windows command*/
win_command_options = '/v /fo list'              /*options  of     "        "       "   */
?3= 'Network Adapter:'                           /*search keywords for Network Adapter. */
?4= 'Physical Address:'                          /*   "       "     "  Physical Address.*/
upper ?3 ?4                                      /*uppercase in case for capitol letters*/
@.=;            @.0= 0                           /*just─in─case values for the keywords.*/
rc= 0                                            /*  "   "   "  value for the returnCode*/
address system win_command win_command_options   with   output stem @.  /*issue command.*/
if rc\==0  then do                               /*display an error if not successful.  */
                say
                say '***error*** from command: '     win_command     win_command_options
                say 'Return code was: '    rc
                say
                exit rc
                end
MACaddr=.                                        /*just─in─case value for the keyword.  */
maker=.                                          /*  "   "   "    "    "   "     "      */
           do j=1  for @.0;  $= @.j;  upper $    /*parse each of the possible responses.*/
           if left($, length(?3))=?3  then maker=   subword(@.j, 3)   /*is this the one?*/
           if left($, length(?4))=?4  then MACaddr= word(@.j, 3)      /* "   "   "   "  */
           end   /*k*/
                                                 /* [↑]  Now, display good or bad stuff.*/
if maker=. | MACaddr==.  then say 'MAC address manufacturer not found.'
                         else say 'manufacturer for MAC address  '  MACaddr "  is  " maker
exit 0                                           /*stick a fork in it,  we're all done. */
