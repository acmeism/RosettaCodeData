Rebol [
    title: "Rosetta code: Fraction reduction"
    file:  %Fraction_reduction.r3
    url:   https://rosettacode.org/wiki/Fraction_reduction
    needs: 3.21.5
]

unless native? :idivide [
    ;; backward compatibility
    idivide: func[a b][to integer! (a / b)]
]

fraction-reduction: function/with [
    lo [integer!] "lower bound of range"
    hi [integer!] "upper bound of range"
    /verbose
][
    len: length? form hi               ;; number of digits
    omitted: array/initial 9  0        ;; ommitted digits counters

    n-digits: clear []                 ;; digit buffer for numerator
    d-digits: clear []                 ;; digit buffer for denominator

    count: 0
    for n lo hi 1 [
        unless get-digits n len n-digits [continue]   ;; skip numbers that don't qualify
        for d n + 1 hi + 1 1 [
            ;; extract and validate denominator digits
            unless get-digits d len d-digits [continue] ;; skip invalid denominators

            repeat ni len [
                all [
                    nv: n-digits/:ni                  ;; get numerator digit
                    di: index?  find d-digits nv      ;; find matching digit in denominator
                    rn: remove-digit n-digits len ni  ;; numerator with shared digit removed
                    rd: remove-digit d-digits len di  ;; denominator with shared digit removed
                    n * rd == (rn * d)                ;; cross-multiply to check n/d = rn/rd
                    ++ count                          ;; increment match counter
                    omitted/:nv: omitted/:nv + 1      ;; track which digit was cancelled
                    verbose                           ;; check if output is needed
                    prin [CR n "/" d "=" rn "/" rd "by omitting" nv "'s"]
                    count <= 12                       ;; only print first 12 matches
                    prin LF                           ;; newline after match
                ]
            ]
        ]
    ]
    if verbose [print "^M^[[K"] ;; clear last line
    ;; return output as a map
    compose/only #[
        digit:   (len)
        count:   (count)
        omitted: (omitted)
    ]
][

    get-digits: function/with [
        ;; extract digits of n, reject if invalid (zero digit, repeated digit)
        num len digits
    ][
        if invalid/:num [return false]
        n: num
        append/dup clear digits 0 len  ;; reset digit buffer
        while [n > 0][
            r: n % 10
            if find digits r [
                invalid/:num: true
                return false
            ]
            digits/:len: r
            -- len
            n: idivide n 10
        ]
        true
    ][
        ;; cache invalid numbers
        invalid: make bitset! []
    ]
    remove-digit: function [digits len idx][
        sum: 0
        pow: pick [1 10 100 1000 10000] len - 1
        repeat i len [
            if i = idx [continue]
            sum: sum + (digits/:i * pow)
            pow: idivide pow 10
        ]
        sum
    ]
]
ranges: [
    12  97
    123 986
    1234 9875
    ;12345 98764
]
foreach [lo hi] ranges [
    print [as-yellow "Using range:" lo "to" hi]
    res: fraction-reduction/verbose lo hi
    print rejoin ["There are " res/count " " res/digit "-digit fractions of which:"]
    repeat i 9 [
        unless zero? v: res/omitted/:i [
            print rejoin [pad v -6 " have " i "'s omitted"]
        ]
    ]
    print ""
]
