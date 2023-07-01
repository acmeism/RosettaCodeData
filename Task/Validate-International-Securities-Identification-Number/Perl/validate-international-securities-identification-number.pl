use strict;
use English;
use POSIX;
use Test::Simple tests => 7;

ok(   validate_isin('US0378331005'),  'Test 1');	
ok( ! validate_isin('US0373831005'),  'Test 2');
ok( ! validate_isin('U50378331005'),  'Test 3');
ok( ! validate_isin('US03378331005'), 'Test 4');
ok(   validate_isin('AU0000XVGZA3'),  'Test 5');	
ok(   validate_isin('AU0000VXGZA3'),  'Test 6');
ok(   validate_isin('FR0000988040'),  'Test 7');	
exit 0;

sub validate_isin {
    my $isin = shift;
    $isin =~ /\A[A-Z]{2}[A-Z\d]{9}\d\z/s or return 0;
    my $base10 = join(q{}, map {scalar(POSIX::strtol($ARG, 36))}
                               split(//s, $isin));
    return luhn_test($base10);
}
