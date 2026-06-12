/*REXX pgm snipette validates a specific type of data structure, an IP v4 address (list)*/
ip= 127 0 0 1
if val_ipv4(ip)  then say                'valid IPV4 type: '    ip
                 else say '***error***  invalid IPV4 type: '    ip
...

exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
val_ipv4: procedure; parse arg $;          if words($)\==4  |  arg()\==1  then return 0
            do j=1  for 4;   _=word($, j);    #=datatype(_, 'W');    L= length(_)
            if verify(_, 0123456789)\==0  |  \#  | _<0  |  _>255  |  L>3  then return 0
            end   /*j*/
          return 1                               /*returns true (1) if valid, 0 if not. */
