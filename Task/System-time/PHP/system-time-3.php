echo date('D M j H:i:s Y'), "\n";  // custom format; see format characters here:
                                   // http://us3.php.net/manual/en/function.date.php
echo date('c'), "\n";  // ISO 8601 format
echo date('r'), "\n";  // RFC 2822 format
echo date(DATE_RSS), "\n";  // can also use one of the predefined formats here:
                            // http://us3.php.net/manual/en/class.datetime.php#datetime.constants.types
