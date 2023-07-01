use Lingua::EN::Numbers 'num2en_ordinal';

printf "%16s : %s\n", $_, num2en_ordinal(0+$_) for
    <1 2 3 4 5 11 65 100 101 272 23456 8007006005004003 123 00123.0 '00123.0' 1.23e2 '1.23e2'>;
