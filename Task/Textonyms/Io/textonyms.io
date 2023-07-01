main := method(
    setupLetterToDigitMapping

    file := File clone openForReading("./unixdict.txt")
    words := file readLines
    file close

    wordCount := 0
    textonymCount := 0
    dict := Map clone
    words foreach(word,
        (key := word asPhoneDigits) ifNonNil(
            wordCount = wordCount+1
            value := dict atIfAbsentPut(key,list())
            value append(word)
            if(value size == 2,textonymCount = textonymCount+1)
        )
    )
    write("There are ",wordCount," words in ",file name)
    writeln(" which can be represented by the digit key mapping.")
    writeln("They require ",dict size," digit combinations to represent them.")
    writeln(textonymCount," digit combinations represent Textonyms.")

    samplers := list(maxAmbiquitySampler, noMatchingCharsSampler)
    dict foreach(key,value,
        if(value size == 1, continue)
        samplers foreach(sampler,sampler examine(key,value))
    )
    samplers foreach(sampler,sampler report)
)

setupLetterToDigitMapping := method(
    fromChars := Sequence clone
    toChars := Sequence clone
    list(
        list("ABC", "2"), list("DEF", "3"), list("GHI", "4"),
        list("JKL", "5"), list("MNO", "6"), list("PQRS","7"),
        list("TUV", "8"), list("WXYZ","9")
    ) foreach( map,
        fromChars appendSeq(map at(0), map at(0) asLowercase)
        toChars alignLeftInPlace(fromChars size, map at(1))
    )

    Sequence asPhoneDigits := block(
        str := call target asMutable translate(fromChars,toChars)
        if( str contains(0), nil, str )
    ) setIsActivatable(true)
)

maxAmbiquitySampler := Object clone do(
    max := list()
    samples := list()
    examine := method(key,textonyms,
        i := key size - 1
        if(i > max size - 1,
            max setSize(i+1)
            samples setSize(i+1)
        )
        nw := textonyms size
        nwmax := max at(i)
        if( nwmax isNil or nw > nwmax,
            max atPut(i,nw)
            samples atPut(i,list(key,textonyms))
        )
    )
    report := method(
        writeln("\nExamples of maximum ambiquity for each word length:")
        samples foreach(sample,
            sample ifNonNil(
                writeln("    ",sample at(0)," -> ",sample at(1) join(" "))
            )
        )
    )
)

noMatchingCharsSampler := Object clone do(
    samples := list()
    examine := method(key,textonyms,
        for(i,0,textonyms size - 2 ,
            for(j,i+1,textonyms size - 1,
                if( _noMatchingChars(textonyms at(i), textonyms at(j)),
                    samples append(list(textonyms at(i),textonyms at(j)))
                )
            )
        )
    )
    _noMatchingChars := method(t1,t2,
        t1 foreach(i,ich,
            if(ich == t2 at(i), return false)
        )
        true
    )
    report := method(
        write("\nThere are ",samples size," textonym pairs which ")
        writeln("differ at each character position.")
        if(samples size > 10, writeln("The ten largest are:"))
        samples sortInPlace(at(0) size negate)
        if(samples size > 10,samples slice(0,10),samples) foreach(sample,
            writeln("    ",sample join(" ")," -> ",sample at(0) asPhoneDigits)
        )
    )
)

main
