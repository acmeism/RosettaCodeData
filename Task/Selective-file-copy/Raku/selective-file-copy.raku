my @format = ( # arbitrary and made up record format
    'field a' => { offset => 0,  length => 5, type => 'Str' },
    'field b' => { offset => 5,  length => 5, type => 'Str' },
    'field c' => { offset => 10, length => 4, type => 'Int' },
    'field d' => { offset => 14, length => 1, type => 'Str' },
    'field e' => { offset => 15, length => 5, type => 'Str' }
);

my $record-length = @format[*]».value».<length>.sum;

my $in = './sfc.dat'.IO.open :r :bin;

say "Input data as read from $in:";
my @records;
@records.push: get-record($in, $record-length) until $in.eof;
.perl.say for @records;

# not going to bother to actually write out to a file, if you really want to,
# supply a file handle to a local file
say "\nOutput:";
my $outfile = $*OUT; # or some other filename, whatever.

for @records -> $r {
    $outfile.printf( "%-5s%s%08x%5s\n", flat $r.{'field a','field d','field c'}, 'xxxxx' );
}

sub get-record($fh, $bytes) {
    my $record = $fh.read($bytes);
    return ().Slip unless $record.elems == $bytes;
    my %r = @format.map: {
        .key => do given $_.value.<type> -> $type
        {
            when $type eq 'Str' { $record.subbuf($_.value.<offset>, $_.value.<length>).decode }
            when $type eq 'Int' { sum $record.subbuf($_.value.<offset>, $_.value.<length>) Z+< (24,16,8,0) }
            default             { $record.subbuf($_.value.<offset>, $_.value.<length>) } # Buf
        }
    }
}
