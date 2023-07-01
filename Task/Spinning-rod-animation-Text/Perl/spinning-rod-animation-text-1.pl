$|= 1;

while () {
    for (qw[ | / - \ ]) {
        select undef, undef, undef, 0.25;
        printf "\r ($_)";
    }
}
