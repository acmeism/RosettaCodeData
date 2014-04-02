sub MAIN ($filename = 'default.ppm') {
    my $width = my $height = 125;

    # Since P6 is a binary format, open in binary mode
    my $out = open( $filename, :w, :bin ) or die "$!\n";

    $out.say("P6\n$width $height\n255");

    for ^$height X ^$width -> $r, $g {
        $out.write(Buf.new($r*2,$g*2,255-$r*2));
    }
    $out.close;
}
