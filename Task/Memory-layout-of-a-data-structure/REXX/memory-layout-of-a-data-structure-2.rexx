/*REXX pgm displays which pins are active of a 9 or 24 pin RS-232 plug. */
call rs_232  24,  127                  /*value for an RS-232 24 pin plug*/
call rs_232  24, '020304x'             /*value for an RS-232 24 pin plug*/
call rs_232   9, '10100000b'           /*value for an RS-232  9 pin plug*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────RS_232 subroutine───────────────────*/
rs_232: arg pins,x; parse arg ,ox      /*x is uppercased when using ARG.*/
@.      = '??? unassigned bit'         /*assigned default for all bits. */
@.24.1  = 'PG  protective ground'
@.24.2  = 'TD  transmitted data'         ;  @.9.3 = @.24.2
@.24.3  = 'RD  received data'            ;  @.9.2 = @.24.3
@.24.4  = 'RTS request to send'          ;  @.9.7 = @.24.4
@.24.5  = 'CTS clear to send'            ;  @.9.8 = @.24.5
@.24.6  = 'DSR data set ready'           ;  @.9.6 = @.24.6
@.24.7  = 'SG  signal ground'            ;  @.9.5 = @.24.7
@.24.8  = 'CD  carrier detect'           ;  @.9.1 = @.24.8
@.24.9  = '+   positive voltage'
@.24.10 = '-   negative voltage'
@.24.12 = 'SCD secondary CD'
@.24.13 = 'SCS secondary CTS'
@.24.14 = 'STD secondary td'
@.24.15 = 'TC  transmit clock'
@.24.16 = 'SRD secondary RD'
@.24.17 = 'RC  receiver clock'
@.24.19 = 'SRS secondary RTS'
@.24.20 = 'DTR data terminal ready'      ;  @.9.4 = @.24.20
@.24.21 = 'SQD signal quality detector'
@.24.22 = 'RI  ring indicator'           ;  @.9.9 = @.24.22
@.24.23 = 'DRS data rate select'
@.24.24 = 'XTC external clock'
         select
         when right(x,1)=='B' then bits=    strip(x,'T',"B")
         when right(x,1)=='X' then bits=x2b(strip(x,'T',"X"))
         otherwise                 bits=x2b(  d2x(x))
         end   /*select*/
bits=right(bits,pins,0)                /*right justify the pin readings.*/
say;  say '───────── For a' pins "pin RS─232 plug, with a reading of: " ox
say
         do j=1  for pins;     z=substr(bits,j,1);    if z==0 then iterate
         say right(j,5)     'pin is "on": '     @.pins.j
         end   /*j*/
return
