my @nums = 64921987050997300559,  70251412046988563035,  71774104902986066597,
           83448083465633593921,  84209429893632345702,  87001033462961102237,
           87762379890959854011,  89538854889623608177,  98421229882942378967,
           259826672618677756753, 262872058330672763871, 267440136898665274575,
           278352769033314050117, 281398154745309057242, 292057004737291582187;

my @factories = @nums.hyper(:3batch).map: *.&prime-factors;
printf "%21d factors: %s\n", |$_ for @nums Z @factories;
my $gmf = {}.append(@factories»[0] »=>« @nums).max: +*.key;
say "\nGreatest minimum factor: ", $gmf.key;
say "from: { $gmf.value }\n";
say 'Run time: ', now - INIT now;
say '-' x 80;

# For amusements sake and for relative comparison, using the same 100
# numbers as in the SequenceL example, testing with different numbers of threads.

@nums = <625070029 413238785 815577134 738415913 400125878 967798656 830022841
   774153795 114250661 259366941 571026384 522503284 757673286 509866901 6303092
   516535622 177377611 520078930 996973832 148686385 33604768 384564659 95268916
   659700539 149740384 320999438 822361007 701572051 897604940 2091927 206462079
   290027015 307100080 904465970 689995756 203175746 802376955 220768968 433644101
   892007533 244830058 36338487 870509730 350043612 282189614 262732002 66723331
   908238109 635738243 335338769 461336039 225527523 256718333 277834108 430753136
   151142121 602303689 847642943 538451532 683561566 724473614 422235315 921779758
   766603317 364366380 60185500 333804616 988528614 933855820 168694202 219881490
   703969452 308390898 567869022 719881996 577182004 462330772 770409840 203075270
   666478446 351859802 660783778 503851023 789751915 224633442 347265052 782142901
   43731988 246754498 736887493 875621732 594506110 854991694 829661614 377470268
   984990763 275192380 39848200 892766084 76503760>».Int;

for 1..8 -> $degree {
    my $start = now;
    my \factories = @nums.hyper(:degree($degree), :3batch).map: *.&prime-factors;
    my $gmf = {}.append(factories»[0] »=>« @nums).max: +*.key;
    say "\nFactoring {+@nums} numbers, greatest minimum factor: {$gmf.key}";
    say "Using: $degree thread{ $degree > 1 ?? 's' !! ''}";
    my $end = now;
    say 'Run time: ', $end - $start, ' seconds.';
}

# Prime factoring routines from the Prime decomposition task
sub prime-factors ( Int $n where * > 0 ) {
    return $n if $n.is-prime;
    return [] if $n == 1;
    my $factor = find-factor( $n );
    sort flat prime-factors( $factor ), prime-factors( $n div $factor );
}

sub find-factor ( Int $n, $constant = 1 ) {
    return 2 unless $n +& 1;
    if (my $gcd = $n gcd 6541380665835015) > 1 {
        return $gcd if $gcd != $n
    }
    my $x      = 2;
    my $rho    = 1;
    my $factor = 1;
    while $factor == 1 {
        $rho *= 2;
        my $fixed = $x;
        for ^$rho {
            $x = ( $x * $x + $constant ) % $n;
            $factor = ( $x - $fixed ) gcd $n;
            last if 1 < $factor;
        }
    }
    $factor = find-factor( $n, $constant + 1 ) if $n == $factor;
    $factor;
}
