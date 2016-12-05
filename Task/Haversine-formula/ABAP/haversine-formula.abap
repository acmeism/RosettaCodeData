  DATA: X1 TYPE F, Y1 TYPE F,
        X2 TYPE F, Y2 TYPE F, YD TYPE F,
        PI TYPE F,
        PI_180 TYPE F,
        MINUS_1 TYPE F VALUE '-1'.

PI     = ACOS( MINUS_1 ).
PI_180 = PI / 180.

LATITUDE1 = 36,12 . LONGITUDE1 = -86,67 .
LATITUDE2 = 33,94 . LONGITUDE2 = -118,4 .

  X1 = LATITUDE1  * PI_180.
  Y1 = LONGITUDE1 * PI_180.
  X2 = LATITUDE2  * PI_180.
  Y2 = LONGITUDE2 * PI_180.
  YD = Y2 - Y1.

  DISTANCE = 20000 / PI *
    ACOS( SIN( X1 ) * SIN( X2 ) + COS( X1 ) * COS( X2 ) * COS( YD ) ).

WRITE : 'Distance between given points = ' , distance , 'km .' .
