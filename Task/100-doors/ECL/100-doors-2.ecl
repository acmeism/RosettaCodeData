Doors := RECORD
  UNSIGNED1 DoorNumber;
  STRING6   State;
END;

AllDoors := DATASET([{0,'0'}],Doors);

//first build the 100 doors

Doors  OpenThem(AllDoors L,INTEGER Cnt) := TRANSFORM
  SELF.DoorNumber := Cnt;
  SELF.State      := 'Closed';
END;

ClosedDoors := NORMALIZE(AllDoors,100,OpenThem(LEFT,COUNTER));

//now iterate through them and use door logic

loopBody(DATASET(Doors) ds, UNSIGNED4 c) :=
            PROJECT(ds,    //ds=original input
              TRANSFORM(Doors,
                      	SELF.State := CASE((COUNTER % c) * 100,
		                            0 => IF(LEFT.STATE = 'Opened','Closed','Opened')
					    ,LEFT.STATE);
			SELF.DoorNumber := COUNTER;     //PROJECT COUNTER
                    ));

g1 := LOOP(ClosedDoors,100,loopBody(ROWS(LEFT),COUNTER));

OUTPUT(g1);
