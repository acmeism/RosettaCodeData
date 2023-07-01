DoorSet := DATASET(100,TRANSFORM({UNSIGNED1 DoorState},SELF.DoorState := 1));
SetDoors := SET(DoorSet,DoorState);

Doors := RECORD
  UNSIGNED1 Pass;
  SET OF UNSIGNED1 DoorSet;
END;

StartDoors := DATASET(100,TRANSFORM(Doors,SELF.Pass := COUNTER,SELF.DoorSet := SetDoors));

Doors XF(Doors L, Doors R) := TRANSFORM
  ds := DATASET(L.DoorSet,{UNSIGNED1 DoorState});
  NextDoorSet := PROJECT(ds,
                         TRANSFORM({UNSIGNED1 DoorState},
                      	           SELF.DoorState := CASE((COUNTER % R.Pass) * 100,
                                                          0 => IF(LEFT.DoorState = 1,0,1),
                                                          LEFT.DoorState)));
  SELF.DoorSet := IF(L.Pass=0,R.DoorSet,SET(NextDoorSet,DoorState));									
  SELF.Pass := R.Pass										
END;										

Res := DATASET(ITERATE(StartDoors,XF(LEFT,RIGHT))[100].DoorSet,{UNSIGNED1 DoorState});
PROJECT(Res,TRANSFORM({STRING20 txt},SELF.Txt := 'Door ' + COUNTER + ' is ' + IF(LEFT.DoorState=1,'Open','Closed')));
