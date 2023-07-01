DECLARE
  TYPE doorsarray IS VARRAY(100) OF BOOLEAN;
  doors doorsarray := doorsarray();
BEGIN

doors.EXTEND(100);  --ACCOMMODATE 100 DOORS

FOR i IN 1 .. doors.COUNT  --MAKE ALL 100 DOORS FALSE TO INITIALISE
  LOOP
     doors(i) := FALSE;
  END LOOP;

FOR j IN 1 .. 100 --ITERATE THRU USING MOD LOGIC AND FLIP THE DOOR RIGHT OPEN OR CLOSE
 LOOP
      FOR k IN 1 .. 100
        LOOP
                  IF MOD(k,j)=0 THEN
                     doors(k) := NOT doors(k);
                  END IF;
        END LOOP;
 END LOOP;

FOR l IN 1 .. doors.COUNT  --PRINT THE STATUS IF ALL 100 DOORS AFTER ALL ITERATION
  LOOP
       DBMS_OUTPUT.PUT_LINE('DOOR '||l||' IS -->> '||CASE WHEN SYS.DBMS_SQLTCB_INTERNAL.I_CONVERT_FROM_BOOLEAN(doors(l)) = 'TRUE'
                                                                THEN 'OPEN'
                                                              ELSE 'CLOSED'
                                                        END);
  END LOOP;

END;
