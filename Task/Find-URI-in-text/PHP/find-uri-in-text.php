$tests = array(
    'this URI contains an illegal character, parentheses and a misplaced full stop:',
    'http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).',
    'and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)',
    '")" is handled the wrong way by the mediawiki parser.',
    'ftp://domain.name/path(balanced_brackets)/foo.html',
    'ftp://domain.name/path(balanced_brackets)/ending.in.dot.',
    'ftp://domain.name/path(unbalanced_brackets/ending.in.dot.',
    'leading junk ftp://domain.name/path/embedded?punct/uation.',
    'leading junk ftp://domain.name/dangling_close_paren)',
    'if you have other interesting URIs for testing, please add them here:',
    'http://www.example.org/foo.html#includes_fragment',
    'http://www.example.org/foo.html#enthält_Unicode-Fragment',
    ' http://192.168.0.1/admin/?hackme=%%%%%%%%%true',
    'blah (foo://domain.hld/))))',
    'https://haxor.ur:4592/~mama/####&?foo'
);

foreach ( $tests as $test ) {
    foreach( explode( ' ', $test ) as $uri ) {
        if ( filter_var( $uri, FILTER_VALIDATE_URL ) )
            echo $uri, PHP_EOL;
    }
}
