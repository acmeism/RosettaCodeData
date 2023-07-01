CREATE OR REPLACE FUNCTION fibLinear(n INTEGER) RETURNS INTEGER AS $$
DECLARE
  prevFib INTEGER := 0;
  fib INTEGER := 1;
BEGIN
  IF (n < 2) THEN
    RETURN n;
  END IF;

  WHILE n > 1 LOOP
    SELECT fib, prevFib + fib INTO prevFib, fib;
    n := n - 1;
  END LOOP;

  RETURN fib;
END;
$$ LANGUAGE plpgsql;
