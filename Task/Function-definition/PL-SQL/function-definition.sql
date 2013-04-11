FUNCTION multiply(p_arg1 NUMBER, p_arg2 NUMBER) RETURN NUMBER
IS
  v_product NUMBER;
BEGIN
  v_product := p_arg1 * p_arg2;
  RETURN v_product;
END;
