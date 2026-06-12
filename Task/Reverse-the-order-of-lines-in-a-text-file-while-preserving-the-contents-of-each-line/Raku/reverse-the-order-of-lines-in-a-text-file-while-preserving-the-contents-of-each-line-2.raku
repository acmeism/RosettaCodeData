my $input-record-separator = "\x00\x00";

my $fh = open("nul.txt".IO, :r, :bin);
$fh.seek(0, SeekFromEnd); # start at the end of the file

my $bytes = 5 min $fh.tell - 1; # read in file 5 bytes at a time (or whatever)

$fh.seek(-$bytes, SeekFromCurrent);

my $buffer = $fh.read($bytes).decode('Latin1'); # assume Latin1 for reduced complexity

loop {
    my $seek = ($fh.tell < $bytes * 2) ?? -$fh.tell !! -$bytes * 2;
    $fh.seek($seek, SeekFromCurrent);
    $buffer = $buffer R~ $fh.read((-$seek - $bytes) max 0).decode('Latin1');
    if $buffer.contains: $input-record-separator {
        my @rest;
        ($buffer, @rest) = $buffer.split: $input-record-separator;
        .say for reverse @rest; # emit any full records that have been processed
    }
    last if $fh.tell < $bytes;
}

say $buffer; # emit any remaining record
