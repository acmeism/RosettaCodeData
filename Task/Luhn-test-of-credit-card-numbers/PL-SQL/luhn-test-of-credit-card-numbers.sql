FUNCTION algoLuhn ( p_numeroVerif VARCHAR2 )
    RETURN NUMBER
  IS
    i         NUMBER;
    v_NBi     SMALLINT;
    v_retour  SMALLINT;
    v_somme   NUMBER := 0;
    v_nbCar   NUMBER;

  BEGIN
    v_nbCar := LENGTH(p_numeroVerif);

    FOR i IN 1..v_nbCar
    LOOP
        v_NBi := TO_NUMBER(SUBSTR(p_numeroVerif,v_nbCar+1-i,1));

        v_somme := v_somme
                  + MOD(i,2)   * v_NBi
                  + MOD(i+1,2) * SIGN(-SIGN(v_Nbi-4)+1) * (2*v_NBi)
                  + MOD(i+1,2) * SIGN( SIGN(v_Nbi-5)+1) * (2*v_NBi-9);

    END LOOP;

    v_retour := SIGN(MOD(v_somme,10));

    RETURN v_retour;

  EXCEPTION
    WHEN OTHERS
      THEN
        RETURN 1;

  END algoLuhn;
