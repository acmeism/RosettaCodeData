sub nacci ( $s = 2, :@start = (1,) ) {
    my @seq = |@start, { state $n = +@start; @seq[ ($n - $s .. $n++ - 1).grep: * >= 0 ].sum } … *;
}

put "{.fmt: '%2d'}-nacci: ", nacci($_)[^20] for 2..12 ;

put "Lucas: ", nacci(:start(2,1))[^20];
