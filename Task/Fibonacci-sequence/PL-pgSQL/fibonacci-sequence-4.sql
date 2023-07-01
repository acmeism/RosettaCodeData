CREATE OR REPLACE FUNCTION fibTailRecursive(n INTEGER, prevFib INTEGER DEFAULT 0, fib INTEGER DEFAULT 1)
RETURNS INTEGER AS $$
BEGIN
  IF (n = 0) THEN
    RETURN prevFib;
  END IF;
  RETURN fibTailRecursive(n - 1, fib, prevFib + fib);
END;
$$ LANGUAGE plpgsql;
