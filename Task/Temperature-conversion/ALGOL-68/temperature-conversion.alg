BEGIN
   REAL kelvin;
   read (kelvin);
   FORMAT f = $g(8,2), " K = ", g(8,2)xgl$;
   printf ((f, kelvin, kelvin - 273.15, "C"));
   printf ((f, kelvin, 9.0 * kelvin / 5.0, "R"));
   printf ((f, kelvin, 9.0 * kelvin / 5.0 - 459.67, "F"))
END
