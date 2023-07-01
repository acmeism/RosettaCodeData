#!/usr/bin/perl
use strict ;
use warnings ;
use Math::BigInt ;

my %countrycodelengths = ( "AL" =>  28, "AD" =>  24, "AT" =>  20, "AZ" =>  28,
                           "BE" =>  16, "BH" =>  22, "BA" =>  20, "BR" =>  29,
                           "BG" =>  22, "CR" =>  21, "HR" =>  21, "CY" =>  28,
			   "CZ" =>  24, "DK" =>  18, "DO" =>  28, "EE" =>  20,
	                   "FO" =>  18, "FI" =>  18, "FR" =>  27, "GE" =>  22,
	                   "DE" =>  22, "GI" =>  23, "GR" =>  27, "GL" =>  18,
	                   "GT" =>  28, "HU" =>  28, "IS" =>  26, "IE" =>  22,
		           "IL" =>  23, "IT" =>  27, "KZ" =>  20, "KW" =>  30,
		           "LV" =>  21, "LB" =>  28, "LI" =>  21, "LT" =>  20,
		           "LU" =>  20, "MK" =>  19, "MT" =>  31, "MR" =>  27,
		           "MU" =>  30, "MC" =>  27, "MD" =>  24, "ME" =>  22,
			   "NL" =>  18, "NO" =>  15, "PK" =>  24, "PS" =>  29,
			   "PL" =>  28, "PT" =>  25, "RO" =>  24, "SM" =>  27,
			   "SA" =>  24, "RS" =>  22, "SK" =>  24, "SI" =>  19,
			   "ES" =>  24, "SE" =>  24, "CH" =>  21, "TN" =>  24,
			   "TR" =>  26, "AE" =>  23, "GB" =>  22, "VG" =>  24 ) ;
sub validate_iban {
   my $ibanstring = shift ;
   $ibanstring =~ s/\s+//g ;
   return 0 unless $ibanstring =~ /[0-9a-zA-Z]+/ ;
   $ibanstring = uc $ibanstring ;
   return 0 if ( not exists $countrycodelengths{ substr( $ibanstring , 0 , 2 ) }  );
   return 0 if length ( $ibanstring ) != $countrycodelengths{ substr( $ibanstring , 0 , 2 ) } ;
   $ibanstring =~ s/(.{4})(.+)/$2$1/ ;
   $ibanstring =~ s/([A-Z])/ord( $1 ) - 55/eg ;
   my $number = Math::BigInt->new( $ibanstring ) ;
   if ( $number->bmod( 97 ) == 1 ) {
      return 1 ;
   }
   else {
      return 0 ;
   }
}

if ( validate_iban( "GB82 WEST 1234 5698 7654 32" ) ) {
   print "GB82 WEST 1234 5698 7654 32 is a valid IBAN number!\n" ;
}
else {
   print "Sorry! GB82 WEST 1234 5698 7654 32 is not valid!\n" ;
}
if ( validate_iban( "GB82TEST12345698765432" ) ) {
   print "GB82TEST12345698765432 is valid!\n" ;
}
