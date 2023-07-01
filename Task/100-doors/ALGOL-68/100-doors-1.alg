# declare some constants #
INT limit = 100;

PROC doors = VOID:
(
  MODE DOORSTATE = BOOL;
  BOOL closed = FALSE;
  BOOL open = NOT closed;
  MODE DOORLIST = [limit]DOORSTATE;

  DOORLIST the doors;
  FOR i FROM LWB the doors TO UPB the doors DO the doors[i]:=closed OD;

  FOR i FROM LWB the doors TO UPB the doors DO
    FOR j FROM LWB the doors TO UPB the doors DO
      IF j MOD i = 0 THEN
        the doors[j] :=  NOT the doors[j]
      FI
    OD
  OD;
  FOR i FROM LWB the doors TO UPB the doors DO
    printf(($g" is "gl$,i,(the doors[i]|"opened"|"closed")))
  OD
);
doors;
