 hex
 3fd constant com1-ctrl
 decimal

 : wait-ready
   begin
     com1-ctrl in
     CTS and
   until ;
 : wait-rx
   begin
     com1-ctrl in
     CTS and 0=
   until ;

 : send-byte ( b -- )   \ send assuming N81 (no parity, 8 bits data, 1 bit frame)
   255 and
   9 0 do
     RTS com1-ctrl out
     wait-ready
     dup 1 and if TxD else 0 then com1-ctrl out
     wait-rx
     2/
   loop drop ;
