sub own-password (Int $password, Int $nonce) {
    my int $n1 = 0;
    my int $n2 = $password;
    for $nonce.comb {
        given $_ {
            when 1 {
                $n1 = $n2 +& 0xFFFFFF80 +> 7;
                $n2 +<= 25;
            }
            when 2 {
                $n1 = $n2 +& 0xFFFFFFF0 +> 4;
                $n2 +<= 28;
            }
            when 3 {
                $n1 = $n2 +& 0xFFFFFFF8 +> 3;
                $n2 +<= 29;
            }
            when 4 {
                $n1 = $n2 +< 1;
                $n2 +>= 31;
            }
            when 5 {
                $n1 = $n2 +< 5;
                $n2 +>= 27;
            }
            when 6 {
                $n1 = $n2 +< 12;
                $n2 +>= 20;
            }
            when 7 {
                $n1 = $n2 +& 0x0000FF00 +| ($n2 +& 0x000000FF +< 24) +| ($n2 +& 0x00FF0000 +> 16);
                $n2 = $n2 +& 0xFF000000 +> 8;
            }
            when 8 {
                $n1 = $n2 +& 0x0000FFFF +< 16 +| $n2 +> 24;
                $n2 = $n2 +& 0x00FF0000 +> 8;
            }
            when 9  { $n1 = +^$n2 }
            default { $n1 = $n2 }
        }
        given $_ {
            when 0 {}
            when 9 {}
            default { $n1 = ($n1 +| $n2) +& 0xFFFFFFFF }
        }
        $n2 = $n1;
    }
    $n1
}

say own-password( 12345, 603356072 );
say own-password( 12345, 410501656 );
say own-password( 12345, 630292165 );
