 # Sample ''utilities'' PROCedure declarations #
PROC cat = ([]GENLINE argv)GENLINE:~;
PROC tee = ([]YIELDLINE args filter)FILTER:~;
PROC grep = (STRING pattern, []GENLINE argv)GENLINE:~;
PROC uniq = (GENLINE arg)GENLINE:~;
PROC sort = (GENLINE arg)GENLINE:~;
PROC head = (INT n, []GENLINE args)GENLINE:~;
PROC tail = (INT n, []GENLINE args)GENLINE:~;
