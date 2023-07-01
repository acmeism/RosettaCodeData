xquery version "3.1";

declare function local:decode-roman-numeral($roman-numeral as xs:string) {
    $roman-numeral
    => upper-case()
    => for-each(
        function($roman-numeral-uppercase) {
            analyze-string($roman-numeral-uppercase, ".")/fn:match
            ! map { "M": 1000, "D": 500, "C": 100, "L": 50, "X": 10, "V": 5, "I": 1 }(.)
        }
    )
    => fold-right([0,0],
        function($number as xs:integer, $accumulator as array(*)) {
            let $running-total := $accumulator?1
            let $previous-number := $accumulator?2
            return
                if ($number lt $previous-number) then
                    [ $running-total - $number, $number ]
                else
                    [ $running-total + $number, $number ]
        }
    )
    => array:get(1)
};

let $roman-numerals :=
    map {
        "MCMXCIX": 1999,
        "MDCLXVI": 1666,
        "XXV": 25,
        "XIX": 19,
        "XI": 11,
        "CMLIV": 954,
        "MMXI": 2011,
        "CD": 400,
        "MCMXC": 1990,
        "MMVIII": 2008,
        "MMIX": 2009,
        "MMMDCCCLXXXVIII": 3888
    }
return
    map:for-each(
        $roman-numerals,
        function($roman-numeral, $expected-value) {
            local:decode-roman-numeral($roman-numeral) eq $expected-value
        }
    )
