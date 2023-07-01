my @Stirling_numbers_of_the_second_kind =
    (1,),
    { (0, |@^last) »+« (|(@^last »*« @^last.keys), 0) } … *
;
my @bell = @Stirling_numbers_of_the_second_kind.map: *.sum;

.say for @bell.head(15), @bell[50 - 1];
