use Date::Manip;
Date_LeapYear($year);

use Date::Manip::Base;
my $dmb = new Date::Manip::Base;
$dmb->leapyear($year);
