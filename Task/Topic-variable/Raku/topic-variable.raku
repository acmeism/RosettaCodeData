$_ = 'Outside';
for <3 5 7 10> {
    print $_;
    .³.map: { say join "\t", '', $_, .², .sqrt, .log(2), OUTER::<$_>, UNIT::<$_>  }
}
