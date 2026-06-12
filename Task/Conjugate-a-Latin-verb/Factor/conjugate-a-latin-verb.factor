USING: formatting io kernel math qw sequences ;

CONSTANT: pronouns {
    "I"
    "you"
    "he, she, it"
    "we"
    "you all"
    "they"
}

CONSTANT: endings qw{ ō ās at āmus ātis ant }

: first-conjugation? ( str -- ? )
    qw{ are āre } [ tail? ] with any? ;

: check-first-conjugation ( str -- )
    first-conjugation?
    [ "Input must end with 'are' or 'āre'." throw ] unless ;

: check-length ( str -- )
    length 3 >
    [ "Input too short to conjugate." throw ] unless ;

: check-input ( str -- )
    [ check-first-conjugation ] [ check-length ] bi ;

: conjugate ( str -- seq )
    dup check-input 3 head* endings [ append ] with map ;

: he/she/it ( str -- newstr )
    "s" append dup dup "he %s, she %s, it %s" sprintf ;

: english ( str -- seq )
    pronouns [ 2 = [ nip he/she/it ] [ " " glue ] if ] with
    map-index ;

:: conjugate. ( la en -- )
    la en "Present active indicative conjugations of %s (%s):\n"
    printf la conjugate en english [ "  %-10s%s\n" printf ] 2each ;

"amāre" "love" conjugate. nl
"dāre" "give" conjugate.
