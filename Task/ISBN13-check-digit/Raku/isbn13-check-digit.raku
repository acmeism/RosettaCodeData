sub check-digit ($isbn) {
     (10 - (sum (|$isbn.comb(/<[0..9]>/)) »*» (1,3)) % 10).substr: *-1
}

{
    my $check = .substr(*-1);
    my $check-digit = check-digit .chop;
    say "$_ : ", $check == $check-digit ??
        'Good' !!
        "Bad check-digit $check; should be $check-digit"
} for words <
    978-0596528126
    978-0596528120
    978-1788399081
    978-1788399083
    978-2-74839-908-0
    978-2-74839-908-5
>;
