Rebol [
    title: "Rosetta code: XXXX redacted"
    file:  %XXXX_redacted.r3
    url:   https://rosettacode.org/wiki/XXXX_redacted
    needs: 3.21.0 ;; Unicode
]

radect-text: function/with [
    mode [any-word! string! ref!] "Any: wsn win psn pin pso pio"
    word [string!]                "Word to hide"
    text [string! file! url!]
][
    unless string? text [text: read/string text]
    mode:  form mode
    rplc:  append/dup clear "" #"X" length? word  ;; replacement: "XXX" same length as word
    case:  mode/2 = #"s"                          ;; s = case-sensitive, n = case-insensitive
    either mode/3 = #"o" [
        ;; Overkill: redact the entire token containing the match
        rule: [
            to word s: (
                unless head? s [s: find/reverse/tail s o-chars]   ;; back up to token start
                e: any [find s o-chars tail s]                    ;; scan forward to token end
                rplc: append/dup clear "" #"X" len: (index? e) - (index? s)  ;; fit XXX to token length
                e: change/part s rplc e
            ) :e
        ]
    ][  ;; Whole / partial match
        rule: either/only mode/1 = #"w" [
            ahead [word w-chars] change word rplc | thru delimit  ;; whole: match word at boundary
        ][                       change word rplc | skip]         ;; partial: match anywhere
    ]
    parse/:case text [any rule]
    text
][  ;; Static charset definitions (shared across all calls)
    w-chars: charset { ^-^/.,;:?}         ;; chars that may follow a whole word
    delimit: charset "- .;:?^/^"[](){}"   ;; token delimiters for whole-word skipping
    o-chars: charset  " .;:?^/^"[](){}"   ;; token boundaries for overkill mode
]

;; Test cases:
text: {Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.}
foreach word ["Tom" "tom"][
    print ["Redact" as-green word ":"]
    foreach mode [wsn win psn pin pso pio][   ;; w/p=whole/partial, s/n=case, o=overkill
        print [mode radect-text :mode :word copy :text]
    ]
]
print ["Redact" "👨" ":"]
probe radect-text 'w "👨" "🧑 👨 🧔 👨‍👩‍👦"   ;; sanity-check Unicode handling
