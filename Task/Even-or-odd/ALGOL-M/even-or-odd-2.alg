% RETURN 1 IF EVEN, OTHERWISE 0 %
INTEGER FUNCTION EVEN(I);
INTEGER I;
BEGIN
  EVEN := (IF I = 2 * (I / 2) THEN 1 ELSE 0);
END;
