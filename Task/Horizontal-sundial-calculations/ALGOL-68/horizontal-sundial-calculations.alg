BEGIN
  REAL lat, slat, lng, ref;
  print ( "Enter latitude       => " ); read (lat);
  print ( "Enter longitude      => " ); read (lng);
  print ( "Enter legal meridian => " ); read (ref);
  new line(stand out);

  slat := sin(lat*2*pi/360) ;
  print ( ("    sine of latitude:   ", float(slat,8,2,1), new line ) );
  print ( ("    diff longitude:     ", fixed((lng - ref),0,3), new line, new line ) );

  print ( ("Hour, sun hour angle, dial hour line angle from 6am to 6pm", new line ));

  FOR h FROM -6 TO 6
  DO
     REAL hra , hla ;              # define hour angle and hour line angle #
     hra := 15 * h ;               # hour angle is 15 times the hour #
     hra := hra - (lng - ref);     # but correct for longitude difference #
     hla := arc tan ( slat * tan(hra*2*pi/360) ) * 360 / ( 2*pi) ;
     # page 132 of a68gdoc.pdf documentationfile #
     print ("HR="+whole(h,3)+"; HRA="+fixed(hra,8,3)+"; HLA="+fixed(hla,8,3));
     new line(stand out)
  OD
END
