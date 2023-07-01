sub caesar {
        my ($message, $key, $decode) = @_;
        $key = 26 - $key if $decode;
        $message =~ s/([A-Z])/chr(((ord(uc $1) - 65 + $key) % 26) + 65)/geir;
}

my $msg = 'THE FIVE BOXING WIZARDS JUMP QUICKLY';
my $enc = caesar($msg, 10);
my $dec = caesar($enc, 10, 'decode');

print "msg: $msg\nenc: $enc\ndec: $dec\n";
