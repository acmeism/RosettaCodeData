use File::Temp;

sub merge_streams ( @streams ) {
    my @s = @streams.map({ hash( STREAM => $_, HEAD => .get ) }).grep({ .<HEAD>.defined });

    return gather while @s {
        my $h = @s.min: +*.<HEAD>;
        take $h<HEAD>;
        $h<HEAD> := $h<STREAM>.get
            orelse @s .= grep( { $_ !=== $h } );
    }
}

sub store (@values) {
    my ($filename,$filehandle) = tempfile(:prefix('external-sort.'));
    $filehandle.say: join "\n", @values.sort: +*;
    $filename
}

# we're going to pretend that this is a long stream of input from stdin...
my (@chunk,@files);
for (<43 2 45 32 15 4 3 -9 45 66 0 42 78 123 -11 76 55 87 -2 64 92 34>) {
    @chunk.push: $_;
    @files.push: store(@chunk) and @chunk = () if @chunk.elems == 4; # limit of records per merge file
}
@files.push: store(@chunk) if @chunk;

say join ' ', merge_streams @files».&open;
