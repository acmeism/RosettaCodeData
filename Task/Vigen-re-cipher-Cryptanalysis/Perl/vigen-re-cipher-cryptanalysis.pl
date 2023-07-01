use strict;
use warnings;
use feature 'say';

# from Wikipedia
my %English_letter_freq = (
     E => 12.70,  L => 4.03,  Y => 1.97,  P => 1.93,  T => 9.06,  A => 8.17,  O => 7.51,  I => 6.97,  N => 6.75,
     S =>  6.33,  H => 6.09,  R => 5.99,  D => 4.25,  C => 2.78,  U => 2.76,  M => 2.41,  W => 2.36,  F => 2.23,
     G =>  2.02,  B => 1.29,  V => 0.98,  K => 0.77,  J => 0.15,  X => 0.15,  Q => 0.10,  Z => 0.07
);
my @alphabet = sort keys %English_letter_freq;
my $max_key_lengths = 5; # number of keylengths to try

sub myguess {
    my ($text) = (@_);
    my ($seqtext, @spacing, @factors, @sortedfactors, $pos, %freq, %Keys);

    # Kasiski examination
    $seqtext = $text;
    while ($seqtext =~ /(...).*\1/) {
        $seqtext = substr($seqtext, 1+index($seqtext, $1));
        push @spacing,  1 + index($seqtext, $1);
    }

    for my $j (@spacing) {
        push @factors, grep { $j % $_ == 0 } 2..$j;
    }
    $freq{$_}++ for @factors;
    @sortedfactors = grep { $_ >= 4 } sort { $freq{$b} <=> $freq{$a} } keys %freq; # discard very short keys

    for my $keylen ( @sortedfactors[0..$max_key_lengths-1] ) {
        my $keyguess = '';
        for (my $i = 0; $i < $keylen; $i++) {
            my($mykey, %chi_values, $bestguess);
            for (my $j = 0; $j < length($text); $j += $keylen) {
                $mykey .= substr($text, ($j+$i) % length($text), 1);
            }

            for my $subkey (@alphabet) {
                my $decrypted = mycrypt($mykey, $subkey);
                my $length    = length($decrypted);
                for my $char (@alphabet) {
                    my $expected = $English_letter_freq{$char} * $length / 100;
                    my $observed;
                    ++$observed while $decrypted =~ /$char/g;
                    $chi_values{$subkey} += ($observed - $expected)**2 / $expected if $observed;
                }
            }

            $Keys{$keylen}{score} = $chi_values{'A'};
            for my $sk (sort keys %chi_values) {
                if ($chi_values{$sk} <= $Keys{$keylen}{score}) {
                    $bestguess = $sk;
                    $Keys{$keylen}{score} = $chi_values{$sk};
                }
            }
            $keyguess .= $bestguess;
        }
        $Keys{$keylen}{key} = $keyguess;
    }
    map { $Keys{$_}{key} } sort { $Keys{$a}{score} <=> $Keys{$b}{score}} keys %Keys;
}

sub mycrypt {
    my ($text, $key) = @_;
    my ($new_text, %values_numbers);

    my $keylen = length($key);
    @values_numbers{@alphabet} = 0..25;
    my %values_letters = reverse %values_numbers;

    for (my $i = 0; $i < length($text); $i++) {
        my $val =  -1 * $values_numbers{substr( $key, $i%$keylen, 1)} # negative shift for decode
                 +      $values_numbers{substr($text, $i,         1)};
        $new_text .= $values_letters{ $val % 26 };
    }
    return $new_text;
}

my $cipher_text = <<~'EOD';
    MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
    VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD
    ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS
    FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG
    ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ
    ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS
    JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT
    LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST
    MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH
    QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV
    RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW
    TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO
    SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR
    ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX
    BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB
    BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA
    FWAML ZZRXJ EKAHV FASMU LVVUT TGK
EOD

my $text = uc($cipher_text) =~ s/[^@{[join '', @alphabet]}]//gr;

for my $key ( myguess($text) ) {
    say "Key        $key\n" .
        "Key length " . length($key) . "\n" .
        "Plaintext  " . substr(mycrypt($text, $key), 0, 80) . "...\n";
}
