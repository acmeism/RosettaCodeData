DECLARE
  --The desired collection
  type t_coll is table of number index by binary_integer;
  l_coll t_coll;

  c_max pls_integer := 1000;
BEGIN
   FOR l_counter IN 1 .. c_max
   LOOP
      -- dbms_random.normal delivers normal distributed random numbers with a mean of 0 and a variance of 1
      -- We just adjust the values and get the desired result:
      l_coll(l_counter) := DBMS_RANDOM.normal * 0.5 + 1;
      DBMS_OUTPUT.put_line (l_coll(l_counter));
   END LOOP;
END;
