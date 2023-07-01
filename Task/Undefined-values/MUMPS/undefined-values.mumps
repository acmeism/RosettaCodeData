 IF $DATA(SOMEVAR)=0 DO UNDEF ; A result of 0 means the value is undefined
 SET LOCAL=$GET(^PATIENT(RECORDNUM,0)) ;If there isn't a defined item at that location, a null string is returned
