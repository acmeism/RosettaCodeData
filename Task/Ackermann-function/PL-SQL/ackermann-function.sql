DECLARE

  FUNCTION ackermann(pi_m IN NUMBER,
                     pi_n IN NUMBER) RETURN NUMBER IS
  BEGIN
    IF pi_m = 0 THEN
      RETURN pi_n + 1;
    ELSIF pi_n = 0 THEN
      RETURN ackermann(pi_m - 1, 1);
    ELSE
      RETURN ackermann(pi_m - 1, ackermann(pi_m, pi_n - 1));
    END IF;
  END ackermann;

BEGIN
  FOR n IN 0 .. 6 LOOP
    FOR m IN 0 .. 3 LOOP
      dbms_output.put_line('A(' || m || ',' || n || ') = ' || ackermann(m, n));
    END LOOP;
  END LOOP;
END;
