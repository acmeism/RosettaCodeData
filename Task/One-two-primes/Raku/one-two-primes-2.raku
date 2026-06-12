for 929,(0,1),229,(1,2),930,(1,3),931,(1,4),932,(1,5),933,(1,6),934,(1,7),935,(1,8),
    936,(1,9),937,(2,3),938,(2,7),939,(2,9),940,(3,4),941,(3,5),942,(3,7),943,(3,8),
    944,(4,7),945,(4,9),946,(5,7),947,(5,9),948,(6,7),949,(7,8),950,(7,9),951,(8,9)
  -> $oeis, $pair {

    say "\nOEIS:A036{$oeis} - Smallest n digit prime using only {$pair[0]} and {$pair[1]} (or '0' if none exists):";

    sub condense ($n) { $n.subst(/(.) {} :my $repeat=$0; ($repeat**{9..*})/, -> $/ {"($0 x {1+$1.chars}) "}) }

    sub build ($digit, $sofar='') { take $sofar and return unless $digit; build($digit-1,$sofar~$_) for |$pair }

    sub get-prime ($digits) {
        ($pair[0] ?? (gather build $digits).first: &is-prime
        !! (gather build $digits-1, $pair[1]).first: &is-prime
        ) // 0
    }

    printf "%4d: %s\n", $_, condense .&get-prime for flat 1..20, 100, 200;
}
