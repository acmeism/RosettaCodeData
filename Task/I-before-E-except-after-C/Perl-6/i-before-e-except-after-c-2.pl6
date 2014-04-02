grammar CollectWords {
    token TOP {
        ^^ \t Word \t PoS \t Freq $$ \n
        [^^ <word> $$ \n?]+
    }

    token word {
        \t+
        [ <with_c> | <no_c> | \T ]+ \t+
        \T+ \t+ # PoS doesn't matter to us, so ignore it
        $<freq>=[<.digit>+] \h*
    }

    token with_c {
        c <ie_part>
    }

    token no_c {
        <ie_part>
    }

    token ie_part {
        ie | ei
    }
}

class CollectWords::Actions {
    method TOP($/) {
        make $<word>».ast».flat.Bag;
    }

    method word($/) {
        if $<with_c> + $<no_c> {
            make ($<with_c>».ast xx $<freq>, $<no_c>».ast xx $<freq>);
        } else {
            make ();
        }
    }

    method with_c($/) {
        make "c" ~ $<ie_part>;
    }

    method no_c($/) {
        make "!c" ~ $<ie_part>;
    }
}

sub plausible($good, $bad, $msg) {
    if $good > 2*$bad {
        say "$msg: PLAUSIBLE ($good ✔ vs. $bad ✘)";
        return True;
    } else {
        say "$msg: NOT PLAUSIBLE ($good ✔ vs. $bad ✘)";
        return False;
    }
}

# can't use .parsefile like before due to the non-Unicode £ in this file.
my $file = slurp("1_2_all_freq.txt", :enc<iso-8859-1>);
my $results = CollectWords.parse($file, :actions(CollectWords::Actions)).ast;

my $phrasetest = [&] plausible($results<!cie>, $results<!cei>, "I before E when not preceded by C"),
                     plausible($results<cei>, $results<cie>, "E before I when preceded by C");

say "I before E except after C: ", $phrasetest ?? "PLAUSIBLE" !! "NOT PLAUSIBLE";
