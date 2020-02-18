CREATE OR REPLACE FUNCTION fibFormula(n INTEGER) RETURNS INTEGER AS $$
BEGIN
  RETURN round(pow((pow(5, .5) + 1) / 2, n) / pow(5, .5));
END;
$$ LANGUAGE plpgsql;
