# Reference:
# https://github.com/retupmoca/P6-SOAP
# http://wiki.dreamfactory.com/DreamFactory/Tutorials/Temp_Conversion_SOAP_API

use v6;
use SOAP::Client;

my $request = SOAP::Client.new('http://www.w3schools.com/xml/tempconvert.asmx?WSDL') or die;

say $request.call('CelsiusToFahrenheit', Celsius => 100 ) or die;

say $request.call('FahrenheitToCelsius', Fahrenheit => 212 ) or die;
