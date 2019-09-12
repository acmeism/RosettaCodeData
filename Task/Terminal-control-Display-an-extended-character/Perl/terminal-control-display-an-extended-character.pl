use feature 'say';

# OK as is
say '￡';

# these need 'binmode needed to surpress warning about 'wide' char
binmode STDOUT, ":utf8";
say "\N{FULLWIDTH POUND SIGN}";
say "\x{FFE1}";
say chr 0xffe1;
