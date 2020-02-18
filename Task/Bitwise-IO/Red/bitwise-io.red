Red [
	Title:      "Bitwise IO"
	Link:       http://rosettacode.org/wiki/Bitwise_IO
	Source:     https://github.com/vazub/rosetta-red
	File:       "%bitwiseio.red"
	Rights:     "Copyright (C) 2020 Vasyl Zubko. All rights reserved."
	License:    "Blue Oak Model License - https://blueoakcouncil.org/license/1.0.0"
	Tabs:       4
]

str-compress: function [
	"Compressesor"
	str [string!]
][
	buf: copy ""
	bit-str: enbase/base str 2
	foreach [bit1 bit2 bit3 bit4 bit5 bit6 bit7 bit8] bit-str [
		append buf rejoin [bit2 bit3 bit4 bit5 bit6 bit7 bit8]
	]
	if (pad-bits: (length? buf) // 8) <> 0 [
		loop (8 - pad-bits) [append buf "0"]
	]
	debase/base buf 2
]

str-expand: function [
	"Decompressor"
	bin-hex [binary!]
][
	bit-str: enbase/base bin-hex 2
	filled: 0
	buf: copy []
	acc: copy ""
	foreach bit bit-str [
		append acc bit
		filled: filled + 1
		if filled = 7 [
			append buf debase/base rejoin ["0" acc] 2
			clear acc
			filled: 0
		]
	]
	if (last buf) = #{00} [take/last buf]
	rejoin buf
]

; DEMO
in-string: "Red forever!"
compressed: str-compress in-string
expanded: str-expand compressed
prin [
	pad "Input (string): " 20 mold in-string newline newline
	pad "Input (bits): " 20 enbase/base in-string 2 newline
	pad "Compressed (bits): " 20 enbase/base compressed 2 newline newline
	pad "Input (hex): " 20 to-binary in-string newline
	pad "Compressed (hex): " 20 compressed newline newline
	pad "Expanded (string): " 20 mold to-string expanded
]
