unit sub MAIN($n = 5);
say 'unixdict.txt'.IO.words.grep( 3 < *.chars < 10 )
.pick($n).map( { .tc ~ (^99).roll.fmt: '%02d' } ).join: '-';
