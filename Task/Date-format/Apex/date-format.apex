Datetime dtNow = datetime.now();
String strDt1 = dtNow.format('yyyy-MM-dd');
String strDt2 = dtNow.format('EEEE, MMMM dd, yyyy');
system.debug(strDt1); // "2007-11-10"
system.debug(strDt2); //"Sunday, November 10, 2007"
