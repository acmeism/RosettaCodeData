/*REXX program parses an  IP address  into  ──►  IPv4  or  IPv6 format,  optional pport.*/
_= "_";    say center('input IP address'   , 30),
               center('hex IP address'     , 32),
               center('decimal IP address' , 39)         "space  port"
           say copies(_, 30)   copies(_, 32)   copies(_, 39)   copies(_, 5)   copies(_, 5)
call IP_parse  127.0.0.1                         /*this simple  IP  doesn't need quotes.*/
call IP_parse '127.0.0.1:80'
call IP_parse '::1'
call IP_parse '[::1]:80'
call IP_parse '2605:2700:0:3::4713:93e3'
call IP_parse '[2605:2700:0:3::4713:93e3]:80'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
IP_parse:  procedure;  parse arg a .;       hx=;              @.=;       numeric digits 50
           dot= pos(., a)\==0                    /*see if there is a dot present in IP. */

           if dot then do;   parse var   a    @.1  '.'  @.2  "."  @.3  '.'  @.4  ":"  port
                                            do j=1  for 4;    hx= hx  ||  d2x(@.j, 2)
                                            end   /*j*/
                       end
                  else do;   parse var  a  pureA  ']:'  port
                       _= space( translate( pureA, , '[]'), 0)        /*remove brackets.*/
                       parse var _ x '::' y
                                            do L=1  until x==''       /*get  left side. */
                                            parse var  x  @.L  ':'  x
                                            end   /*L*/
                       y= reverse(y)
                                            do r=8  by -1             /*get right side. */
                                            parse var  y  z  ':'  y;   if z=='' then leave
                                            @.r= reverse(z)
                                            end   /*r*/

                            do k=1  for 8;  hx=hx  ||  right( word(@.k 0, 1), 4, 0)
                            end   /*k*/
                       end

           say left(a,30) right(hx,32) right(x2d(hx),39) ' IPv' || (6-2*dot) right(port,5)
           return
