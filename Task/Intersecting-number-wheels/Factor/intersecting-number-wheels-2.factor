USING: generalizations io kernel prettyprint
rosetta-code.number-wheels ;

NUMBER-WHEELS:
A: 1 2 3
;

NUMBER-WHEELS:
A: 1 B 2
B: 3 4
;

NUMBER-WHEELS:
A: 1 D D
D: 6 7 8
;

NUMBER-WHEELS:
A: 1 B C
B: 3 4
C: 5 B
;

[
    "Intersecting number wheel group:" print
    [ . ] [ "Generates:" print 20 swap .take nl ] bi
] 4 napply
