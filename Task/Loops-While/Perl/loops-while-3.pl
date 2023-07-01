my $n = 1024;
until($n == 0){
    print "$n\n";
    $n = int $n / 2;
}
