Doors := RECORD
 UNSIGNED1 DoorNumber;
 STRING6   State;
END;

AllDoors := DATASET([{0,0}],Doors);

Doors  OpenThem(AllDoors L,INTEGER Cnt) := TRANSFORM
 SELF.DoorNumber := Cnt;
 SELF.State      := IF((CNT * 10) % (SQRT(CNT)*10)<>0,'Closed','Opened');
END;

OpenDoors := NORMALIZE(AllDoors,100,OpenThem(LEFT,COUNTER));

OpenDoors;
