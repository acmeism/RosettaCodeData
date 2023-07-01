CompareThem(INTEGER A,INTEGER B) := FUNCTION
  Result            := A <=> B;
  STRING ResultText := CASE (Result,1 => 'is greater than', 0 => 'is equal to','is less than');
  RETURN A + ' ' + TRIM(ResultText) + ' ' + B;
END;

CompareThem(1,2); //Shows "1 is less than 2"
CompareThem(2,2); //Shows "2 is equal to 2"
CompareThem(2,1); //Shows "2 is greater than 1"
