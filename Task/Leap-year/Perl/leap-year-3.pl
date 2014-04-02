use Date::Manip;
print Date_LeapYear(2000);

use Date::Manip::Base;
my $dmb = new Date::Manip::Base;
print $dmb->leapyear(2000);

use DateTime;
my $date = DateTime->new(year => 2000);
print $date->is_leap_year();
