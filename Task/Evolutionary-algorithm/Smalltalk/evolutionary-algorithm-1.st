String subclass: Mutant [
    <shape: #character>

    Target := Mutant from: 'METHINKS IT IS LIKE A WEASEL'.
    Letters := ' ABCDEFGHIJKLMNOPQRSTUVWXYZ'.

    Mutant class >> run: c rate: p
        ["Run Evolutionary algorighm, using c copies and mutate rate p."
        | pool parent |
        parent := self newRandom.
        pool := Array new: c+1.

        [parent displayNl.
        parent = Target] whileFalse:
            [1 to: c do: [:i | pool at: i put: (parent copy mutate: p)].
            pool at: c+1 put: parent.
            parent := pool fold: [:winner :each | winner fittest: each]]]

    Mutant class >> newRandom
        [^(self new: Target size)
            initializeToRandom;
            yourself]

    initializeToRandom
        [self keys do: [:i | self at: i put: self randomLetter]]

    mutate: p
        [self keys do:
            [:i |
            Random next <= p ifTrue: [self at: i put: self randomLetter]]]

    fitness
        [| score |
        score := 0.
        self with: Target do:
            [:me :you |
            me = you ifTrue: [score := score + 1]].
        ^score]

    fittest: aMutant
        [^self fitness > aMutant fitness
            ifTrue: [self]
            ifFalse: [aMutant]]

    randomLetter
        [^Letters at: (Random between: 1 and: Letters size)]
]
