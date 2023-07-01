foreach $1 ([{-0.0}, {_Inf, "1.0/0"}, {-_Inf, "-1.0/0"}, {_NaN}]) {
    () = printf("%S", $1[0]);
    if (length($1) > 1) () = printf("\t%S\n", eval($1[1]));
    else () = printf("\n");
}
