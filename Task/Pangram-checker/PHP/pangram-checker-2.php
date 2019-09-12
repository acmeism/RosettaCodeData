function is_pangram( $sentence ) {

    // define "alphabet"
    $alpha = range( 'a', 'z' );

    // split lowercased string into array
    $a_sentence = str_split( strtolower( $sentence ) );

    // check that there are no letters present in alpha not in sentence
    return empty( array_diff( $alpha, $a_sentence ) );

}

$tests = array(
    "The quick brown fox jumps over the lazy dog.",
    "The brown fox jumps over the lazy dog.",
    "ABCDEFGHIJKL.NOPQRSTUVWXYZ",
    "ABC.D.E.FGHI*J/KL-M+NO*PQ R\nSTUVWXYZ",
    "How vexingly quick daft zebras jump",
    "Is hotdog?",
    "How razorback-jumping frogs can level six piqued gymnasts!"
);

foreach ( $tests as $txt ) {
    echo '"', $txt, '"', PHP_EOL;
    echo is_pangram( $txt ) ? "Yes" : "No", PHP_EOL, PHP_EOL;
}
