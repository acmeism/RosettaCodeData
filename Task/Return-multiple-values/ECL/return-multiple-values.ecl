MyFunc(INTEGER i1,INTEGER i2) := FUNCTION
  RetMod := MODULE
    EXPORT INTEGER Add  := i1 + i2;
    EXPORT INTEGER Prod := i1 * i2;
  END;
  RETURN RetMod;
END;

//Reference each return value separately:
MyFunc(3,4).Add;
MyFunc(3,4).Prod;
