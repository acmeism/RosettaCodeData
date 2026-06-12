sub two_sum ( @numbers, $sum ) {
    die '@numbers is not sorted' unless [<=] @numbers;

    my ( $i, $j ) = 0, @numbers.end;
    while $i < $j {
        given $sum <=> @numbers[$i,$j].sum {
            when Order::More { $i += 1 }
            when Order::Less { $j -= 1 }
            when Order::Same { return $i, $j }
        }
    }
    return;
}

say two_sum ( 0, 2, 11, 19, 90 ), 21;
say two_sum ( 0, 2, 11, 19, 90 ), 25;
