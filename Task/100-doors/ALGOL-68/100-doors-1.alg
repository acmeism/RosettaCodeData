PROC doors = (INT limit)VOID:
(
  MODE DOORSTATE = BOOL;
  BOOL closed = FALSE;
  BOOL open = NOT closed;
  MODE DOORLIST = [limit]DOORSTATE;

  DOORLIST the doors;
  FOR i FROM LWB the doors TO UPB the doors DO the doors[i]:=closed OD;

  FOR i FROM LWB the doors TO UPB the doors DO
    FOR j FROM LWB the doors BY i TO UPB the doors DO
      the doors[j] := NOT the doors[j]
    OD
  OD;
  FOR i FROM LWB the doors TO UPB the doors DO
    print((whole(i,-12)," is ",(the doors[i]|"opened"|"closed"),newline))
  OD
);
doors(100)
