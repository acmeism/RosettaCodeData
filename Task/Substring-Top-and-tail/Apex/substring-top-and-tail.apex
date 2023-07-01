String strOrig = 'brooms';
String str1 = strOrig.substring(1, strOrig.length());
system.debug(str1);
String str2 = strOrig.substring(0, strOrig.length()-1);
system.debug(str2);
String str3 = strOrig.substring(1, strOrig.length()-1);
system.debug(str3);

// Regular Expressions approach
String strOrig = 'brooms';
String str1 = strOrig.replaceAll( '^.', '' );
system.debug(str1);
String str2 = strOrig.replaceAll( '.$', '' ) ;
system.debug(str2);
String str3 = strOrig.replaceAll( '^.|.$', '' );
system.debug(str3);
