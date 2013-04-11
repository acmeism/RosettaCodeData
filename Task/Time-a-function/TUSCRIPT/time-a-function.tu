$$ MODE TUSCRIPT
SECTION test
LOOP n=1,999999
rest=MOD (n,1000)
IF (rest==0) Print n
ENDLOOP
ENDSECTION
time_beg=TIME ()
DO test
time_end=TIME ()
interval=TIME_INTERVAL (seconds,time_beg,time_end)
PRINT "'test' start at ",time_beg
PRINT "'test' ends  at ",time_end
PRINT "'test' takes ",interval," seconds"
