my $ppm = open("munching0.ppm", :w) orelse .die;

$ppm.print(q :to 'EOT');
P3
256 256
255
EOT

for 0 .. 255 -> $row {
    for 0 .. 255 -> $col {
        my $color = $row +^ $col;
        $ppm.print("0 $color 0 ");
    }
    $ppm.say();
}

$ppm.close();
