    | bottles |
    Transcript clear.
    bottles := '{1} {2} of beer on the wall
    {1} {2} of beer
    Take one down, pass it around
    {3} {4} of beer on the wall'.
    99 to: 1 by: -1 do: [:i |
        Transcript
            show: (bottles format: {
                i. 'bottle' asPluralBasedOn: i.
                i - 1. 'bottle' asPluralBasedOn: i - 1});
            cr; cr].
    Transcript show: 'hic!'; cr.
