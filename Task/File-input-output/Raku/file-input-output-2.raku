my $in = open "input.txt";
my $out = open "output.txt", :w;
for $in.lines -> $line {
    $out.say: $line;
}
$in.close;
$out.close;
