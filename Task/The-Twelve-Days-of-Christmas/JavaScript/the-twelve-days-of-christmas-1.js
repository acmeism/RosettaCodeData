var days = [
    'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth',
    'tenth', 'eleventh', 'twelfth',
];

var gifts = [
    "A partridge in a pear tree",
    "Two turtle doves",
    "Three french hens",
    "Four calling birds",
    "Five golden rings",
    "Six geese a-laying",
    "Seven swans a-swimming",
    "Eight maids a-milking",
    "Nine ladies dancing",
    "Ten lords a-leaping",
    "Eleven pipers piping",
    "Twelve drummers drumming"
];

var lines, verses = [], song;

for ( var i = 0; i < 12; i++ ) {

    lines = [];
    lines[0] = "On the " + days[i] + " day of Christmas, my true love gave to me";

    var j = i + 1;
    var k = 0;
    while ( j-- > 0 )
        lines[++k] = gifts[j];


    verses[i] = lines.join('\n');

    if ( i == 0 )
        gifts[0] = "And a partridge in a pear tree";

}

song = verses.join('\n\n');
document.write(song);
