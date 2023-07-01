sub encode {
    my $source = shift;
    my $key = shift;
    my $out = q();

    @ka = split //, $key;
    foreach $ch (split //, $source) {
        $idx = ord($ch) - 32;
        $out .= $ka[$idx];
    }

    return $out;
}

sub decode {
    my $source = shift;
    my $key = shift;
    my $out = q();

    foreach $ch (split //, $source) {
        $idx = index $key, $ch;
        $val = chr($idx + 32);
        $out .= $val;
    }

    return $out;
}

my $key = q(]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\C1yxJ);
my $text = "Here we have to do is there will be a input/source "
         . "file in which we are going to Encrypt the file by replacing every "
         . "upper/lower case alphabets of the source file with another "
         . "predetermined upper/lower case alphabets or symbols and save "
         . "it into another output/encrypted file and then again convert "
         . "that output/encrypted file into original/decrypted file. This "
         . "type of Encryption/Decryption scheme is often called a "
         . "Substitution Cipher.";

my $ct = encode($text, $key);
print "Encoded: $ct\n";

my $pt = decode($ct, $key);
print "Decoded: $pt\n";
