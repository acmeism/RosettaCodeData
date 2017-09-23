grammar CollectWords {
    token TOP {
        [^^ <word> $$ \n?]+
    }

    token word {
        [ <with_c> | <no_c> | \N ]+
    }

    token with_c {
        c <ie_part>
    }

    token no_c {
        <ie_part>
    }

    token ie_part {
        ie | ei | eie # a couple words in the list have "eie"
    }
}

class CollectWords::Actions {
    method TOP($/) {
        make $<word>».ast.flat.Bag;
    }

    method word($/) {
        if $<with_c> + $<no_c> {
            make flat $<with_c>».ast, $<no_c>».ast;
        } else {
            make ();
        }
    }

    method with_c($/) {
        make "c" X~ $<ie_part>.ast;
    }

    method no_c($/) {
        make "!c" X~ $<ie_part>.ast;
    }

    method ie_part($/) {
        if ~$/ eq 'eie' {
            make ('ei', 'ie');
        } else {
            make ~$/;
        }
    }
}

sub plausible($good, $bad, $msg) {
    if $good > 2*$bad {
        say "$msg: PLAUSIBLE ($good  vs. $bad ✘)";
        return True;
    } else {
        say "$msg: NOT PLAUSIBLE ($good  vs. $bad ✘)";
        return False;
    }
}

my $results = CollectWords.parsefile("unixdict.txt", :actions(CollectWords::Actions)).ast;

my $phrasetest = [&] plausible($results<!cie>, $results<!cei>, "I before E when not preceded by C"),
                     plausible($results<cei>, $results<cie>, "E before I when preceded by C");

say "I before E except after C: ", $phrasetest ?? "PLAUSIBLE" !! "NOT PLAUSIBLE";
