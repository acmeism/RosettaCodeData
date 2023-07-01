DECLARE
  pi NUMBER := 4 * atan(1);
  radians NUMBER := pi / 4;
  degrees NUMBER := 45.0;
BEGIN
  DBMS_OUTPUT.put_line(SIN(radians) || ' ' || SIN(degrees * pi/180) );
  DBMS_OUTPUT.put_line(COS(radians) || ' ' || COS(degrees * pi/180) );
  DBMS_OUTPUT.put_line(TAN(radians) || ' ' || TAN(degrees * pi/180) );
  DBMS_OUTPUT.put_line(ASIN(SIN(radians)) || ' ' || ASIN(SIN(degrees * pi/180)) * 180/pi);
  DBMS_OUTPUT.put_line(ACOS(COS(radians)) || ' ' || ACOS(COS(degrees * pi/180)) * 180/pi);
  DBMS_OUTPUT.put_line(ATAN(TAN(radians)) || ' ' || ATAN(TAN(degrees * pi/180)) * 180/pi);
end;
