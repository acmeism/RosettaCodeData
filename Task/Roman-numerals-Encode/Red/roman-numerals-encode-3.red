to-Roman: function [n [integer!]] reduce [
    'case collect [
        foreach [a r] [1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL 10 X 9 IX 5 V 4 IV 1 I][
            keep compose/deep [n >= (a) [append copy (form r) any [to-Roman n - (a) copy ""]]]
        ]	
    ]
]

foreach number [40 33 1888 2016][print [number ":" to-Roman number]]
