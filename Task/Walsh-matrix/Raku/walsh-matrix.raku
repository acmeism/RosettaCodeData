sub walsh (\m) { (map {$_?? -1 !! ' 1'}, map { :3(.base: 2) % 2 }, [X+&] ^2**m xx 2 ).batch: 2**m }

sub natural (@row) { Same }

sub sign-changes (@row) { sum (1..^@row).map: { 1 if @row[$_] !== @row[$_ - 1] } }

use SVG;

for &natural, 'natural', &sign-changes, 'sequency' -> &sort, $sort {
    for 2,4,5 -> $order {
        # ASCII text
        .put for "\nWalsh matrix - order $order ({exp($order,2)} x {exp($order,2)}), $sort order:", |walsh($order).sort: &sort;

        # SVG image
        my $side = 600;
        my $scale = $side / 2**$order;
        my $row = 0;
        my @blocks;
        my %C = ' 1' => '#0F0', '-1' => '#F00';

        for walsh($order).sort: &sort -> @row {
            my \x = $row++ * $scale;
            for @row.kv {
                my \y = $^k * $scale;
                @blocks.push: (:rect[:x(x),:y(y),:width($scale),:height($scale),:fill(%C{$^v})]);
            }
        }

        "walsh-matrix--order-{$order}--{$sort}-sort-order--raku.svg".IO.spurt:
          SVG.serialize(:svg[:width($side),:height($side),:stroke<black>,:stroke-width<1>,|@blocks])
    }
}
