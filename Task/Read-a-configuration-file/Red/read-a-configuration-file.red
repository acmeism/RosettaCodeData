Red ["Read a config file"]

remove-each l lines: read/lines %file.conf [any [empty? l #"#" = l/1]]
foreach line lines [
	foo: parse line [collect [keep to [" " | end] skip keep to end]]
	either foo/1 = #";" [set to-word foo/2 false][
		set to-word foo/1 any [
			all [find foo/2 #"," split foo/2 ", "]
			foo/2
			true
		]
	]
]
foreach w [fullname favouritefruit needspeeling seedsremoved otherfamily][
	prin [pad w 15 ": "] probe get w
]
