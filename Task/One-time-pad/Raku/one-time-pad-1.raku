sub MAIN {
    put "Generate data for one time pad encryption.\n" ~
        "File will have .1tp extension.";
    my $fn;
    loop {
        $fn = prompt 'Filename for one time pad data: ';
        if $fn !~~ /'.1tp' $/ { $fn ~= '.1tp' }
        if $fn.IO.e {
            my $ow = prompt "$fn aready exists, over-write? y/[n] ";
            last if $ow ~~ m:i/'y'/;
            redo;
        }
        last;
    }

    put 'Each line will contain 48 characters of encyption data.';
    my $lines = prompt 'How many lines of data to generate? [1000] ';
    $lines ||= 1000;
    generate($fn, $lines);
    say "One-time-pad data saved to: ", $fn.IO.absolute;

    sub generate ( $fn, $lines) {
        use Crypt::Random;
        $fn.IO.spurt: "# one-time-pad encryption data\n" ~
          ((sprintf(" %s %s %s %s %s %s %s %s\n",
          ((('A'..'Z')[crypt_random_uniform(26)] xx 6).join) xx 8))
          xx $lines).join;
    }
}
