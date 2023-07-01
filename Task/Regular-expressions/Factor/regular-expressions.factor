USING: io kernel prettyprint regexp ;
IN: rosetta-code.regexp

"1000000" R/ 10+/ matches? .     ! Does the entire string match the regexp?
"1001"    R/ 10+/ matches? .
"1001"    R/ 10+/ re-contains? . ! Does the string contain the regexp anywhere?

"blueberry pie" R/ \p{alpha}+berry/ "pumpkin" re-replace print
