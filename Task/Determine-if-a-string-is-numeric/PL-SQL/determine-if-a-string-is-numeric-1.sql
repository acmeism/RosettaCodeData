FUNCTION IsNumeric( value IN VARCHAR2 )
RETURN BOOLEAN
IS
  help NUMBER;
BEGIN
  help := to_number( value );
  return( TRUE );
EXCEPTION
  WHEN others THEN
    return( FALSE );
END;
