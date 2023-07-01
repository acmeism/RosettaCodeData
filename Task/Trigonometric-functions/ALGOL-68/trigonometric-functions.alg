main:(
  REAL pi = 4 * arc tan(1);
  # Pi / 4 is 45 degrees. All answers should be the same. #
  REAL radians = pi / 4;
  REAL degrees = 45.0;
  REAL temp;
  # sine #
  print((sin(radians), " ", sin(degrees * pi / 180), new line));
  # cosine #
  print((cos(radians), " ", cos(degrees * pi / 180), new line));
  # tangent #
  print((tan(radians), " ", tan(degrees * pi / 180), new line));
  # arcsine #
  temp := arc sin(sin(radians));
  print((temp, " ", temp * 180 / pi, new line));
  # arccosine #
  temp := arc cos(cos(radians));
  print((temp, " ", temp * 180 / pi, new line));
  # arctangent #
  temp := arc tan(tan(radians));
  print((temp, " ", temp * 180 / pi, new line))
)
