sub s2v ($s) { $s.uc.comb(/ <[ A..Z ]> /)».ord »-» 65 }
sub v2s (@v) { (@v »%» 26 »+» 65)».chr.join }

sub hide   ($secret, $otp) { v2s(s2v($secret) »+» s2v($otp)) }
sub reveal ($hidden, $otp) { v2s(s2v($hidden) »-» s2v($otp)) }

sub otp-data ($fn, $lines) {
    my $fh = $fn.IO.open :rw;
    my $data;
    my $count = 0;
    repeat {
        my $pos = $fh.tell;
        my $line = $fh.get;
        if $line.substr(0,1) ne '-'|'#' {
            $data ~= $line;
            $fh.seek($pos);
            $fh.put: '-' ~ $line.substr(1);
            $count++;
        }
    } until $count == $lines or $fh.eof;
    note "Insufficient lines of data remaining in $fn" if $count != $lines;
    $data;
}

sub otp-size (Str $string) { ceiling $string.uc.comb(/ <[ A..Z ]> /) / 48 }

sub otp-encrypt ( $secret, $fn ) {
    my $otp-size = otp-size $secret;
    my $otp-data = otp-data($fn, $otp-size);
    my $encrypted = hide $secret, $otp-data;
    # pad encryted text out to a full line with random text
    $encrypted ~= ('A'..'Z').roll while $encrypted.chars % 48;
    join "\n", $encrypted.comb(6).rotor(8, :partial).map:
      { sprintf "{ join ' ', "%s" xx $_ }", $_ };
}

sub otp-decrypt ( $secret, $fn ) {
    my $otp-size = otp-size $secret;
    my $otp-data = otp-data($fn, $otp-size);
    my $plain-text = reveal $secret, $otp-data;
    join "\n", $plain-text.comb(6).rotor(8, :partial).map:
      { sprintf "{ join ' ', "%s" xx $_ }", $_ };
}

my $otp-encrypt-fn = 'rosettacode.1tp';
my $otp-decrypt-fn = 'rosettacopy.1tp';

my $secret = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";

say "Secret:\n$secret\n\nEncrypted:";
say my $encrypted =   otp-encrypt $secret,    $otp-encrypt-fn;
say "\nDecrypted:\n", otp-decrypt $encrypted, $otp-decrypt-fn;
