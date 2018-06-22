; Functional code
balanced-brackets: [#"[" any balanced-brackets #"]"]
rule: [any balanced-brackets end]
balanced?: func [str][parse str rule]

; Tests
tests: [
	good: ["" "[]" "[][]" "[[]]" "[[][]]" "[[[[[]]][][[]]]]"]
	bad:  ["[" "]" "][" "[[]" "[]]" "[]][[]" "[[[[[[]]]]]]]"]
]

foreach str tests/good [
	if not balanced? str [print [mold str "failed!"]]
]
foreach str tests/bad [
	if balanced? str [print [mold str "failed!"]]
]

repeat i 10 [
	str: random copy/part "[][][][][][][][][][]" i * 2
	print [mold str "is" either balanced? str ["balanced"]["unbalanced"]]
]
