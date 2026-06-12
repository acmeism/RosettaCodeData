prefixLength := [:a :b |
                    |end|
                    end := (a size) min:(b size).
                    ((1 to:end) detect:[:i | (a at:i) ~= (b at:i)] ifNone:end+1)-1].

lcp := [:words |
            words isEmpty
                ifTrue:['']
                ifFalse:[
                    |first l|
                    first := words first.
                    l := (words from:2)
                            inject:first size
                            into:[:minSofar :w | minSofar min:(prefixLength value:first value:w)].
                    first copyTo:l]].

#(
    ('interspecies' 'interstellar' 'interstate')
    ('throne' 'throne')
    ('throne' 'dungeon')
    ('throne' '' 'throne')
    ('cheese')
    ('')
    ()
    ('prefix' 'suffix')
    ('foo' 'foobar')
) do:[:eachList |
    Transcript show:eachList storeString; show:' ==> '; showCR:(lcp value:eachList)
]
