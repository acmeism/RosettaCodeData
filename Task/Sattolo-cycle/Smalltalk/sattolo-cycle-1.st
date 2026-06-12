SequenceableCollection extend [

    sattoloCycle
        [1 to: self size-1 do:
            [:a || b |
            b := Random between: a+1 and: self size.
            self swap: a with: b]]
]
