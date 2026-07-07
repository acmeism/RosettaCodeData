Rebol [
    title: "Rosetta code: Stack traces"
    file:  %Stack_traces.r3
    url:   https://rosettacode.org/wiki/Stack_traces
]

stack-info: function[depth [integer!]][
    print [as-yellow "Current stack depth:" stack/depth 0]
    print [as-yellow "Stack bounds:       " stack/limit 0]
    print  as-yellow "Stack functions (with arguments):"
    n: 1
    while [all [n < depth w: stack/word n]][
        print as-green w   ;= Function or object name, if known
        probe stack/args n ;= Block of args
        print ""
        ++ n
    ]
]

fun1: does [stack-info 6]
fun2: does [fun1]
fun2

print-hline
print "Using TRACE function:"
trace on
fun3: does [print "function3"]
fun3
trace off
