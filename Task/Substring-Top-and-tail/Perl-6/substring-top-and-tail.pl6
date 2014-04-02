my $s = '𝄪♯♮♭𝄫';

print qq:to/END/;
    Original:
    $s

    Remove first character:
    { substr($s, 1) }
    { $s.substr(1) }

    Remove last character:
    { substr($s, 0, *-1) }
    { $s.substr( 0, *-1) }
    { $s.chop }

    Remove first and last characters:
    { substr($s, 1, *-1) }
    { $s.substr(1, *-1) }
    END
