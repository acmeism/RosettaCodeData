compress := [:string |
    String streamContents:[:out |
        string asRunArray runsDo:[:count :char |
            count printOn:out. out nextPut:char]]].
