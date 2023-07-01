bagOfChars := 'someFile' asFilename contentsAsString asBag.
bag sortedCounts
    select:[:assoc | assoc value isLetter ]
    thenDo:[:assoc | assoc printCR].
