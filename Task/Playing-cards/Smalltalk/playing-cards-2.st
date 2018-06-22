Object subclass: Deck [

    | cards |

    Deck class >> of: aCardClass
        [^self new
            initializeWith: aCardClass;
            yourself]

    initializeWith: aCardClass
        [cards := OrderedCollection from: aCardClass standardSet]

    displayOn: aStream
        [cards
            do: [:each | each displayOn: aStream]
            separatedBy: [aStream space]]

    shuffle
        [1 to: cards size - 1 do:
            [:a || b |
            b := Random between: a and: cards size.
            cards swap: a with: b]]

    deal
        [^cards removeLast]
]

Object subclass: Card [

    Card class >> standardSet
        [^#(
            '2d' '3d' '4d' '5d' '6d' '7d' '8d' '9d' 'Td' 'Jd' 'Qd' 'Kd' 'Ad'
            '2s' '3s' '4s' '5s' '6s' '7s' '8s' '9s' 'Ts' 'Js' 'Qs' 'Ks' 'As'
            '2h' '3h' '4h' '5h' '6h' '7h' '8h' '9h' 'Th' 'Jh' 'Qh' 'Kh' 'Ah'
            '2c' '3c' '4c' '5c' '6c' '7c' '8c' '9c' 'Tc' 'Jc' 'Qc' 'Kc' 'Ac'
        ) deepCopy]
]
