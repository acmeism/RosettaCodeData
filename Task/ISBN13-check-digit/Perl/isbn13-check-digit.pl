use strict;
use warnings;
use feature 'say';

sub check_digit {
    my($isbn) = @_; my($sum);
    $sum += (1,3)[$_%2] * (split '', join '', split /\D/, $isbn)[$_] for 0..11;
    (10 - $sum % 10) % 10;
}

for (<978-1734314502 978-1734314509 978-1788399081 978-1788399083 978-2-74839-908-0 978-2-74839-908-5>) {
    my($isbn,$check) = /(.*)(.)/;
    my $check_d = check_digit($isbn);
    say "$_ : " . ($check == $check_d ? 'Good' : "Bad check-digit $check; should be $check_d")
}
