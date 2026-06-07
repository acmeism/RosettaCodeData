Rebol [
    title: "Rosetta code: Named parameters"
    file:  %Named_parameters.r3
    url:   https://rosettacode.org/wiki/Named_parameters
]

print as-yellow "Method 1: Using refinements as named parameters"
func1: func [
    /with-name1 paramname1 [any-type!]
    /with-name2 paramname2 [any-type!]
][
    if with-name1 [print ["paramname1 =" paramname1]]
    if with-name2 [print ["paramname2 =" paramname2]]
]

func1/with-name2/with-name1 "argument2" "argument1"      ;; reordered: name2 before name1
func1/with-name1/with-name2 "argument1" "argument2"      ;; canonical order
func1/with-name2 "only-arg2"                             ;; paramname1 omitted entirely


print as-yellow "Method 2: Using a map as a named-parameter record"
func2: func [params [map!]][
    print ["paramname1 =" params/paramname1]             ;; missing keys return none
    print ["paramname2 =" params/paramname2]
]

func2 #[paramname2: "argument2" paramname1: "argument1"] ;; reordered
func2 #[paramname1: "argument1" paramname2: "argument2"] ;; canonical order
func2 #[paramname1: "only-arg1"]                         ;; paramname2 omitted, returns none


print as-yellow "Method 3: Using a block or object as a named-parameter record"
func3: func [params [block! object!]][
    print ["paramname1 =" select params 'paramname1]     ;; select returns none if absent
    print ["paramname2 =" select params 'paramname2]
]

func3 [paramname2: "argument2" paramname1: "argument1"]  ;; reordered
func3 [paramname1: "argument1" paramname2: "argument2"]  ;; canonical order
func3 [paramname1: "only-arg1"]                          ;; paramname2 omitted, returns none


print as-yellow "Method 4: Context-binding"

call-named: func [f [function!] args [block!] /local ctx words][
    ctx: make object! args                    ;; bind name: value pairs into an object
    ;; words-of extracts param names; map-each feeds them in definition order
    words: words-of :f                        ;; get param names in definition order
    apply :f map-each w words [get in ctx w]  ;; apply positionally
]

func4: func [paramname1 paramname2][
    print ["paramname1 =" paramname1]
    print ["paramname2 =" paramname2]
]

call-named :func4 [paramname2: "argument2" paramname1: "argument1"] ;; reordered
call-named :func4 [paramname1: "first"     paramname2: "second"]    ;; canonical order
