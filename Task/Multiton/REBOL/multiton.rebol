Rebol [
    title: "Rosetta code: Multiton"
    file:  %Multiton.r3
    url:   https://rosettacode.org/wiki/Multiton
]

;; Define the valid multiton types
multiton-types: [ZERO ONE TWO]

;; Create the instances map and pre-load all available instances
multiton-instances: make map! []

;; Object factory to create a multiton with a given type
make-multiton: func [aType [word!]] [
    make object! [
        type: aType
        to-string: func [] [
            rejoin ["This is Multiton " type]
        ]
    ]
]

;; Pre-load instances for all valid types (analogous to Java's static initializer block)
foreach t multiton-types [
    multiton-instances/:t: make-multiton t
]

;; getInstance equivalent - returns the instance or none if type is not valid
get-instance: func [type [word!]] [
    select multiton-instances type
]

; --- Main ---
alpha: get-instance 'ZERO
beta:  get-instance 'ZERO
gamma: get-instance 'ONE
delta: get-instance 'TWO

print alpha/to-string
print beta/to-string
print gamma/to-string
print delta/to-string
