say m[
    ( .*? )

    [
        \s+
        (
        | \d+ [ \- | \/ ] \d+
        | <!before 1940 | 1945> \d+ <[ a..z I . / \x20 ]>* \d*
        )
    ]?

    $
] for lines;
