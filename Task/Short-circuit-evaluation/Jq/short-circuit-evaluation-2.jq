$ jq -r -n -f Short-circuit-evaluation.jq
and:
"  a(true)"
"  b(true)"
true
or:
"  a(true)"
true
and:
"  a(false)"
false
or:
"  a(false)"
"  b(true)"
true
