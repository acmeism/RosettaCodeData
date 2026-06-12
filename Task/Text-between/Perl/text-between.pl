use feature 'say';

sub text_between {
    my($text, $start, $end) = @_;
    return join ',', $text =~ /$start(.*?)$end/g;
}

$text = 'Hello Rosetta Code world';

# String start and end delimiter
say '1> '. text_between($text,  'Hello ', ' world' );

# Regex string start delimiter
say '2> '. text_between($text,  qr/^/, ' world' );

# Regex string end delimiter
say '3> '. text_between($text,  'Hello ',  qr/$/ );

# End delimiter only valid after start delimiter
say '4> '. text_between('</div><div style="chinese">你好嗎</div>', '<div style="chinese">', '</div>' );

# End delimiter not found, default to string end
say '5> '. text_between('<text>Hello <span>Rosetta Code</span> world</text><table style="myTable">', '<text>', qr/<table>|$/ );

# Start delimiter not found, return blank string
say '6> '. text_between('<table style="myTable"><tr><td>hello world</td></tr></table>', '<table>', '</table>' );

# Multiple end delimiters, match frugally
say '7> '. text_between( 'The quick brown fox jumps over the lazy other fox', 'quick ', ' fox' );

# Multiple start delimiters, match frugally
say '8> '. text_between( 'One fish two fish red fish blue fish', 'fish ', ' red' );

# Start delimiter is end delimiter
say '9> '. text_between('FooBarBazFooBuxQuux', 'Foo', 'Foo' );

# Return all matching strings when multiple matches are possible
say '10> '. text_between( $text, 'e', 'o' );

# Ignore start and end delimiter string embedded in longer words
$text = 'Soothe a guilty conscience today, string wrangling is not the best tool to use for this job.';
say '11> '.  text_between($text, qr/\bthe /, qr/ to\b/);
