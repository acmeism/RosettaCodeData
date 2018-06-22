ArrayedCollection extend [

    permuteAndDo: aBlock
        ["Permute receiver in-place, and call aBlock.
        Requires integer keys."
        self permuteUpto: self size andDo: aBlock]

    permuteUpto: n andDo: aBlock
        [n = 0 ifTrue: [^aBlock value].
        1 to: n do:
            [:i |
            self swap: i with: n.
            self permuteUpto: n-1 andDo: aBlock.
            self swap: i with: n]]
]

SequenceableCollection extend [

    permutations
        ["Answer a ReadStream of permuted shallow copies of receiver."
        | c |
        c := MappedCollection
            collection: self
            map: self keys asArray.
        ^Generator on:
            [:g |
            c map permuteAndDo: [g yield: (c copyFrom: 1 to: c size)]]]
