# from Wikipedia
constant %English-letter-freq = (
     E => 12.70,  L => 4.03,  Y => 1.97,  P => 1.93,  T => 9.06,  A => 8.17,  O => 7.51,  I => 6.97,  N => 6.75,
     S =>  6.33,  H => 6.09,  R => 5.99,  D => 4.25,  C => 2.78,  U => 2.76,  M => 2.41,  W => 2.36,  F => 2.23,
     G =>  2.02,  B => 1.29,  V => 0.98,  K => 0.77,  J => 0.15,  X => 0.15,  Q => 0.10,  Z => 0.07
);
constant @alphabet = %English-letter-freq.keys.sort;
constant max_key_lengths = 5; # number of keylengths to try

sub myguess ($text) {
    my ($seqtext, @spacing, @factors, $pos, %freq, %Keys);

    # Kasiski examination
    $seqtext = $text;
    while ($seqtext ~~ /$<sequence>=[...].*$<sequence>/) {
        $seqtext = substr($seqtext, 1+index($seqtext, $<sequence>));
        push @spacing, 1 + index($seqtext, $<sequence>);
    }
    for @spacing -> $j {
        %freq{$_}++ for grep { $j %% $_ }, 2..$j;
    }

    # discard very short keys, and test only the most likely remaining key lengths
    (%freq.keys.grep(* > 3).sort({%freq{$_}}).tail(max_key_lengths)).race(:1batch).map: -> $keylen {
        my $key-guess = '';
        loop (my $i = 0; $i < $keylen; $i++) {
            my ($mykey, %chi-square, $best-guess);
            loop (my $j = 0; $j < $text.chars; $j += $keylen) {
                $mykey ~= substr($text, ($j+$i) % $text.chars, 1);
            }

            for @alphabet -> $subkey {
                my $decrypted = mycrypt($mykey, $subkey);
                my $length    = $decrypted.chars;
                for @alphabet -> $char {
                    my $expected = %English-letter-freq{$char} * $length / 100;
                    my $observed = $decrypted.comb.grep(* eq $char).elems;
                    %chi-square{$subkey} += ($observed - $expected)² / $expected if $observed;
                }
            }
            %Keys{$keylen}{'score'} = %chi-square{@alphabet[0]};
            for %chi-square.keys.sort -> $sk {
                if (%chi-square{$sk} <= %Keys{$keylen}{'score'}) {
                    $best-guess = $sk;
                    %Keys{$keylen}{'score'} = %chi-square{$sk};
                }
            }
            $key-guess ~= $best-guess;
        }
        %Keys{$keylen}{'key'} = $key-guess;
    }
    %Keys.keys.sort({ %Keys{$_}{'score'} }).map:{ %Keys{$_}{'key'} };
}

sub mycrypt ($text, $key) {
    constant %values-numbers = @alphabet Z=> ^@alphabet;
    constant %values-letters = %values-numbers.invert;

    my ($new-text);
    my $keylen = $key.chars;
    loop (my $i = 0; $i < $text.chars; $i++) {
        my $val =  -1 * %values-numbers{substr( $key, $i%$keylen, 1)} # negative shift for decode
                 +      %values-numbers{substr($text, $i,         1)};
        $new-text ~= %values-letters{ $val % @alphabet };
    }
    return $new-text;
}

my $cipher-text = .uc.trans(@alphabet => '', :c) given q:to/EOD/;
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

for myguess($cipher-text) -> $key {
    say "Key        $key\n" ~
        "Key length {$key.chars}\n" ~
        "Plaintext  {substr(mycrypt($cipher-text, $key), 0, 80)}...\n";
}
