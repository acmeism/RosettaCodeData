SET SERVEROUTPUT ON
DECLARE
  c_limit CONSTANT PLS_INTEGER := 25000;
  TYPE t_nums IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  v_nums t_nums;
  v_ludic t_nums;
  v_count_ludic PLS_INTEGER;
  v_count_pos PLS_INTEGER;
  v_pos PLS_INTEGER;
  v_next_ludic PLS_INTEGER;

  FUNCTION is_ludic(p_num PLS_INTEGER) RETURN BOOLEAN IS
  BEGIN
    FOR i IN 1..v_ludic.COUNT LOOP
      EXIT WHEN v_ludic(i) > p_num;
      IF v_ludic(i) = p_num THEN
        RETURN TRUE;
      END IF;
    END LOOP;
    RETURN FALSE;
  END;

BEGIN
  FOR i IN 1..c_limit LOOP
    v_nums(i) := i;
  END LOOP;

  v_count_ludic := 1;
  v_next_ludic := 1;
  v_ludic(v_count_ludic) := v_next_ludic;
  v_nums.DELETE(1);

  WHILE v_nums.COUNT > 0 LOOP
    v_pos := v_nums.FIRST;
    v_next_ludic := v_nums(v_pos);
    v_count_ludic := v_count_ludic + 1;
    v_ludic(v_count_ludic) := v_next_ludic;
    v_count_pos := 0;
    WHILE v_pos IS NOT NULL LOOP
      IF MOD(v_count_pos, v_next_ludic) = 0 THEN
        v_nums.DELETE(v_pos);
      END IF;
      v_pos := v_nums.NEXT(v_pos);
      v_count_pos := v_count_pos + 1;
    END LOOP;
  END LOOP;

  dbms_output.put_line('Generate and show here the first 25 ludic numbers.');
  FOR i IN 1..25 LOOP
    dbms_output.put(v_ludic(i) || ' ');
  END LOOP;
  dbms_output.put_line('');

  dbms_output.put_line('How many ludic numbers are there less than or equal to 1000?');
  v_count_ludic := 0;
  FOR i IN 1..v_ludic.COUNT LOOP
    EXIT WHEN v_ludic(i) > 1000;
    v_count_ludic := v_count_ludic + 1;
  END LOOP;
  dbms_output.put_line(v_count_ludic);

  dbms_output.put_line('Show the 2000..2005''th ludic numbers.');
  FOR i IN 2000..2005 LOOP
    dbms_output.put(v_ludic(i) || ' ');
  END LOOP;
  dbms_output.put_line('');

  dbms_output.put_line('A triplet is any three numbers x, x + 2, x + 6 where all three numbers are also ludic numbers.');
  dbms_output.put_line('Show all triplets of ludic numbers < 250 (Stretch goal)');
  FOR i IN 1..v_ludic.COUNT LOOP
    EXIT WHEN (v_ludic(i)+6) >= 250;
    IF is_ludic(v_ludic(i)+2) AND is_ludic(v_ludic(i)+6) THEN
      dbms_output.put_line(v_ludic(i) || ', ' || (v_ludic(i)+2) || ', ' || (v_ludic(i)+6));
    END IF;
  END LOOP;

END;
/
