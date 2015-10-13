#!/usr/bin/env perl6

my $tmpfile = tmpfile;

sub MAIN ($file, *%changes) {
    %changes.=map({; .key.uc => .value });
    my %seen;

    my $out = open $tmpfile, :w;

    for $file.IO.lines {
        when /:s ^ ('#' .* | '') $/ {
            say $out: ~$0;
        }
        when /:s ^ (';'+)? [(\w+) (\w+)?]? $/ {
            next if !$1 or %seen{$1.uc}++;
            my $new = %changes{$1.uc}:delete;
            say $out: format-line $1, |( !defined($new)  ?? ($2, !$0)  !!
                                         $new ~~ Bool    ?? ($2, $new) !! ($new, True) );
        }
        default {
            note "Malformed line: $_\nAborting.";
            exit 1;
        }
    }

    say $out: format-line .key, |(.value ~~ Bool ?? (Nil, .value) !! (.value, True))
        for %changes;

    run 'mv', $tmpfile, $file; # work-around for NYI `move $tmpfile, $file;`
}

END { unlink $tmpfile if $tmpfile.IO.e }


sub format-line ($key, $value, $enabled) {
    ("; " if !$enabled) ~ $key.uc ~ (" $value" if defined $value);
}

sub tmpfile {
    $*SPEC.catfile: $*SPEC.tmpdir, ("a".."z").roll(20).join
}
