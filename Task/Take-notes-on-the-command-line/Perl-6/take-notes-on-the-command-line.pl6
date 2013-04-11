my $file = 'notes.txt';

multi MAIN() {
    print slurp($file);
}

multi MAIN(*@note) {
    my $fh = open($file, :a);
    $fh.say: DateTime.now, "\n\t", @note;
    $fh.close;
}
