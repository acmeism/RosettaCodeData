my %F = ( # arbitrary and made up record format
    'field a' => { offset => 0,  length => 5, type => 'Str' },
    'field b' => { offset => 5,  length => 5, type => 'Str' },
    'field c' => { offset => 10, length => 4, type => 'Bit' },
    'field d' => { offset => 14, length => 1, type => 'Str' },
    'field e' => { offset => 15, length => 5, type => 'Str' }
);

$record_length += $F{$_}{'length'} for keys %F;

open $fh, '<', 'sfc.dat' || die;
while ($n=sysread($fh, $record, $record_length)) {
    last if $n < $record_length;
    for $k (sort keys %F) {
        if ($F{$k}{type} eq 'Str') {
            printf "$k : %s ", $v = substr $record, $F{$k}{offset}, $F{$k}{length};
            $h{$k} = $v;
        } elsif ($F{$k}{type} eq 'Bit') {
            printf "$k : %d ", $v = substr $record, $F{$k}{offset}, $F{$k}{length};
            $h{$k} = pack("B8",'0011'.$v);;
        }
    }
    print "\n";
    push @result, sprintf( "%-5s%s%01d%5s", $h{'field a'}, $h{'field d'}, $h{'field c'}, 'xxxxx' );
}
print "\n" . join "\n", @result;
