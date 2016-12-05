Layout := RECORD
  UNSIGNED1 RecID1;
  UNSIGNED1 RecID2;
  STRING30  txt;
END;	
Beers := DATASET(99,TRANSFORM(Layout,
                              SELF.RecID1 := COUNTER,SELF.RecID2 := 0,SELF.txt := ''));

Layout XF(Layout L,INTEGER C) := TRANSFORM
  IsOneNext := L.RecID1-1 = 1;
  IsOne := L.RecID1 = 1;
  SELF.txt := CHOOSE(C,
                     (STRING)(L.RecID1-1) + ' bottle'+IF(IsOneNext,'','s')+' of beer on the wall',
                     'Take one down, pass it around',
                     (STRING)(L.RecID1) + ' bottle'+IF(IsOne,'','s')+' of beer',
                     (STRING)(L.RecID1) + ' bottle'+IF(IsOne,'','s')+' of beer on the wall','');
  SELF.RecID2 := C;
  SELF := L;
END;

Rev := NORMALIZE(Beers,5,XF(LEFT,COUNTER));
OUTPUT(SORT(Rev,-Recid1,-RecID2),{txt},ALL);														
