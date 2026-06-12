say my $string = 'Rosettacode is a programming crestomathy site 😀.    🍨 👨‍👩‍👦 ⚽ ¯\_(ツ)_/¯';

say "\nHex dump UTF-16BE, offset 0";
hexdump $string.encode("UTF-16BE");

say "\nHex dump UTF-16LE, offset 0";
hexdump $string.encode("UTF-16LE");

say "\nBinary dump UTF-8, offset 17";
hexdump $string.encode("UTF-8"), :bin, :17offset;

sub hexdump(Blob $blob, Int :$offset is copy = 0, :$bin = False) {
    my ($fmt, $space, $batch) = $bin ?? ("%08b", ' ' x 8, 6) !! ("%02X", '  ', 16);
    for $blob.skip($offset).batch($batch) {
        my @h = flat $_».fmt($fmt), $space xx $batch;
        @h[7] ~= ' ';
        printf "%08X  %s  |%s|\n", $offset, @h[^$batch].Str,
           $_».chr.join.subst(/<-print>|\t|\n/, '.', :g);
        $offset += $batch;
    }
}
